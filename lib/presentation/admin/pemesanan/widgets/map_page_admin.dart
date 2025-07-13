import 'dart:async';

import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class MapPage extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String? customerName; // Opsional: untuk menampilkan nama pelanggan di info window

  const MapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.customerName,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _customerMarker;
  String? _customerAddress;
  CameraPosition? _initialCamera;

  @override
  void initState() {
    super.initState();
    _setupCustomerLocation();
  }

  // Helper function to join non-null strings with a comma
  String _joinNonNull(List<String?> parts) {
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  Future<void> _setupCustomerLocation() async {
    try {
      final double lat = double.parse(widget.latitude);
      final double lng = double.parse(widget.longitude);
      final LatLng customerLatLng = LatLng(lat, lng);

      _initialCamera = CameraPosition(
        target: customerLatLng,
        zoom: 15, // Zoom yang sesuai untuk melihat lokasi spesifik
      );

      // Mencari alamat dari koordinat
      final placemarks = await placemarkFromCoordinates(lat, lng);

      String addressSnippet = 'Alamat tidak ditemukan';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _customerAddress = _joinNonNull([p.street, p.subLocality, p.locality, p.administrativeArea, p.country]);
        addressSnippet = _joinNonNull([p.street, p.locality]);
      } else {
        _customerAddress = 'Alamat tidak ditemukan untuk lokasi ini.';
      }

      // Buat marker untuk lokasi pelanggan
      _customerMarker = Marker(
        markerId: const MarkerId('customer_location'),
        position: customerLatLng,
        infoWindow: InfoWindow(
          title: widget.customerName?.isNotEmpty == true ? widget.customerName : 'Lokasi Pelanggan',
          snippet: addressSnippet,
        ),
      );

      setState(() {});
    } catch (e) {
      // Jika parsing koordinat gagal atau ada masalah lain
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 2); // Fallback ke view global
      _customerAddress = 'Gagal memuat lokasi: ${e.toString()}';
      setState(() {});
      print('Error setting up customer location: $e'); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat lokasi pelanggan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lokasi Pelanggan',
          style: GoogleFonts.amarante(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamera!,
              myLocationEnabled: false, // Tidak perlu lokasi saya
              myLocationButtonEnabled: false, // Tidak perlu tombol lokasi saya
              mapType: MapType.normal,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              markers: _customerMarker != null ? {_customerMarker!} : {},
              onMapCreated: (GoogleMapController ctrl) {
                _ctrl.complete(ctrl);
                // Tampilkan info window marker secara otomatis setelah peta dibuat
                if (_customerMarker != null) {
                  _ctrl.future.then((controller) {
                    controller.showMarkerInfoWindow(_customerMarker!.markerId);
                  });
                }
              },
              // onTap dihapus karena ini adalah peta tampilan saja
            ),
            Positioned(
              top: 25,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Alamat Pelanggan:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _customerAddress ?? 'Memuat alamat...',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
