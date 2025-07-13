// --- MapPage (Implementasi Google Maps Anda) ---
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  String? _currentAddress;
  CameraPosition? _initialCamera;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  // Helper function to join non-null strings with a comma
  String _joinNonNull(List<String?> parts) {
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  Future<void> _setupLocation() async {
    try {
      final pos = await getPermissions();
      _currentPosition = pos;
      _initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15, // Zoom lebih dekat
      );

      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _currentAddress = _joinNonNull([p.name, p.street, p.locality, p.country]);

        // Set marker awal ke lokasi saat ini
        _pickedMarker = Marker(
          markerId: const MarkerId('picked'),
          position: LatLng(pos.latitude, pos.longitude),
          infoWindow: InfoWindow(
            title: p.name?.isNotEmpty == true ? p.name : 'Lokasi Saat Ini',
            snippet: _joinNonNull([p.street, p.locality]),
          ),
        );
        _pickedAddress = _currentAddress; // Set alamat yang dipilih secara default
        print('Initial Location: Latitude: ${pos.latitude}, Longitude: ${pos.longitude}, Address: $_currentAddress'); // DEBUG
      } else {
        _currentAddress = 'Alamat tidak ditemukan';
        print('Initial Location: No placemarks found for current position.'); // DEBUG
      }

      setState(() {});
    } catch (e) {
      // Jika gagal (denied, service off), fallback ke view global
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 2); // Zoom out untuk view global
      setState(() {});
      print('Error setting up location: $e'); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi saat ini: ${e.toString()}')),
      );
    }
  }

  Future<Position> getPermissions() async {
    // 1. Cek service GPS
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location service belum aktif. Mohon aktifkan GPS Anda.';
    }

    // 2. Cek & minta permission
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw 'Izin lokasi ditolak. Aplikasi memerlukan izin lokasi.';
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen. Mohon berikan izin lokasi di pengaturan aplikasi.';
    }

    // 3. Semua oke, ambil posisi
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); // Akurasi tinggi
  }

  Future<void> _onTap(LatLng latlng) async {
    final placemarks = await placemarkFromCoordinates(
      latlng.latitude,
      latlng.longitude,
    );

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      setState(() {
        _pickedMarker = Marker(
          markerId: const MarkerId('picked'),
          position: latlng,
          infoWindow: InfoWindow(
            title: p.name?.isNotEmpty == true ? p.name : 'Lokasi Dipilih',
            snippet: _joinNonNull([p.street, p.locality]),
          ),
        );
        // Animasi kamera ke lokasi yang dipilih
        _ctrl.future.then((controller) {
          controller.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));
        });

        _pickedAddress = _joinNonNull([p.street, p.locality, p.country]);
        print('Map Tapped: Latitude: ${latlng.latitude}, Longitude: ${latlng.longitude}, Address: $_pickedAddress'); // DEBUG
      });
    } else {
      setState(() {
        _pickedMarker = Marker(
          markerId: const MarkerId('picked'),
          position: latlng,
          infoWindow: const InfoWindow(
            title: 'Lokasi Dipilih',
            snippet: 'Alamat tidak ditemukan',
          ),
        );
        _pickedAddress = 'Alamat tidak ditemukan untuk lokasi ini.';
        print('Map Tapped: No placemarks found for tapped position.'); // DEBUG
      });
    }
  }

  void _confirmSelection() {
    if (_pickedMarker == null || _pickedAddress == null || _pickedAddress!.isEmpty || _pickedAddress! == 'Alamat tidak ditemukan untuk lokasi ini.') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih lokasi yang valid di peta terlebih dahulu.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Alamat'),
        content: Text(_pickedAddress!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Mengembalikan Map berisi alamat, latitude, dan longitude
              final resultData = {
                'address': _pickedAddress!,
                'latitude': _pickedMarker!.position.latitude,
                'longitude': _pickedMarker!.position.longitude,
              };
              print('Returning from MapPage: $resultData'); // DEBUG
              Navigator.pop(context, resultData);
            },
            child: const Text('Pilih'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Alamat')),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamera!,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal, // Ubah ke normal jika satellite terlalu gelap
              compassEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              trafficEnabled: false, // Mungkin tidak perlu di sini
              buildingsEnabled: true,
              indoorViewEnabled: false, // Mungkin tidak perlu di sini
              onMapCreated: (GoogleMapController ctrl) {
                _ctrl.complete(ctrl);
              },
              markers: _pickedMarker != null ? {_pickedMarker!} : {},
              onTap: _onTap,
            ),
            Positioned(
              top: 25,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _currentAddress ?? 'Mencari lokasi Anda...',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (_pickedAddress != null && _pickedAddress!.isNotEmpty && _pickedAddress! != 'Alamat tidak ditemukan untuk lokasi ini.')
              Positioned(
                bottom: 80, // Sesuaikan posisi agar tidak tumpang tindih dengan FAB
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Alamat yang Dipilih:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _pickedAddress!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Posisikan di tengah bawah
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_pickedMarker != null && _pickedAddress != null && _pickedAddress!.isNotEmpty && _pickedAddress! != 'Alamat tidak ditemukan untuk lokasi ini.') // Tampilkan tombol "Pilih Alamat" hanya jika marker sudah ada dan alamat valid
            FloatingActionButton.extended(
              onPressed: _confirmSelection,
              heroTag: 'confirm',
              label: const Text("Pilih Alamat"),
              icon: const Icon(Icons.check),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          const SizedBox(height: 16), // Jarak antara tombol
          // Tombol untuk menghapus pilihan (opsional, bisa dihilangkan jika tidak dibutuhkan)
          // FloatingActionButton.extended(
          //   heroTag: 'clear',
          //   label: const Text('Hapus Pilihan'),
          //   icon: const Icon(Icons.clear),
          //   onPressed: (){
          //     setState(() {
          //       _pickedAddress = null;
          //       _pickedMarker = null;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}