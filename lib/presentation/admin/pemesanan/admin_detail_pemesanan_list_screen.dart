
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_pemesanan_response_model.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/admin_pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/admin/pemesanan/widgets/map_page_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/repository/admin_repository.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';



class AdminDetailPemesananScreen extends StatefulWidget {
  final PemesananData pemesanan;

  const AdminDetailPemesananScreen({super.key, required this.pemesanan});

  @override
  State<AdminDetailPemesananScreen> createState() => _AdminDetailPemesananScreenState();
}

class _AdminDetailPemesananScreenState extends State<AdminDetailPemesananScreen> {
  final List<String> _statusOptions = ['pending', 'confirmed', 'completed', 'cancelled', 'paid'];
  late String _selectedStatus;
  late PemesananData _currentPemesanan; // State lokal untuk data pemesanan yang bisa berubah

  @override
  void initState() {
    super.initState();
    _currentPemesanan = widget.pemesanan; // Inisialisasi dengan data dari widget
    _selectedStatus = _currentPemesanan.status ?? 'pending';
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: valueStyle ?? GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'paid':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pemesanan',
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
      body: BlocProvider(
        create: (context) => AdminPemesananBloc(
          adminRepository: AdminRepository(ServiceHttpClient()),
        ),
        child: BlocConsumer<AdminPemesananBloc, AdminPemesananState>(
          listener: (context, state) {
            if (state is AdminPemesananActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // Perbarui _currentPemesanan dengan instance baru yang memiliki status yang diperbarui
              setState(() {
                _currentPemesanan = _currentPemesanan.copyWith(status: _selectedStatus);
              });
              // Mengembalikan 'true' ke layar sebelumnya (AdminPemesananScreen)
              // untuk menandakan bahwa ada pembaruan yang terjadi.
              Navigator.of(context).pop(true);
            } else if (state is AdminPemesananActionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminPemesananUpdating) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemesanan ID: #${_currentPemesanan.id ?? 'N/A'}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Divider(height: 30, thickness: 1),
                      _buildDetailRow(
                        'Status',
                        _currentPemesanan.status ?? 'N/A',
                        valueStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(_currentPemesanan.status),
                        ),
                      ),
                      _buildDetailRow('Pelanggan', _currentPemesanan.pelanggan?.name ?? 'N/A'),
                      _buildDetailRow('Barber', _currentPemesanan.barber?.name ?? 'N/A'),
                      _buildDetailRow('Layanan', _currentPemesanan.service?.name ?? 'N/A'),
                      _buildDetailRow(
                        'Waktu Terjadwal',
                        _currentPemesanan.scheduledTime != null
                            ? '${_currentPemesanan.scheduledTime!.day}/${_currentPemesanan.scheduledTime!.month}/${_currentPemesanan.scheduledTime!.year} ${_currentPemesanan.scheduledTime!.hour}:${_currentPemesanan.scheduledTime!.minute.toString().padLeft(2, '0')}'
                            : 'N/A',
                      ),
                      _buildDetailRow('Alamat', _currentPemesanan.alamat ?? 'N/A'),
                      _buildDetailRow('Latitude', _currentPemesanan.latitude ?? 'N/A'),
                      _buildDetailRow('Longitude', _currentPemesanan.longitude ?? 'N/A'),
                      _buildDetailRow('Ongkir', 'Rp ${_currentPemesanan.ongkir ?? '0'}'),
                      _buildDetailRow('Total Harga', 'Rp ${_currentPemesanan.totalPrice ?? '0'}'),
                      _buildDetailRow(
                        'Dibuat Pada',
                        _currentPemesanan.createdAt != null
                            ? '${_currentPemesanan.createdAt!.day}/${_currentPemesanan.createdAt!.month}/${_currentPemesanan.createdAt!.year} ${_currentPemesanan.createdAt!.hour}:${_currentPemesanan.createdAt!.minute.toString().padLeft(2, '0')}'
                            : 'N/A',
                      ),
                      _buildDetailRow(
                        'Diperbarui Pada',
                        _currentPemesanan.updatedAt != null
                            ? '${_currentPemesanan.updatedAt!.day}/${_currentPemesanan.updatedAt!.month}/${_currentPemesanan.updatedAt!.year} ${_currentPemesanan.updatedAt!.hour}:${_currentPemesanan.updatedAt!.minute.toString().padLeft(2, '0')}'
                            : 'N/A',
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Ubah Status Pemesanan:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        items: _statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status.toUpperCase(), style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPemesanan.id != null) {
                              context.read<AdminPemesananBloc>().add(
                                    UpdatePemesananStatusEvent(
                                      id: _currentPemesanan.id!,
                                      status: _selectedStatus,
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('ID Pemesanan tidak tersedia untuk diperbarui.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Simpan Status Baru',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_currentPemesanan.latitude != null && _currentPemesanan.longitude != null &&
                          _currentPemesanan.latitude!.isNotEmpty && _currentPemesanan.longitude!.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(
                                    latitude: _currentPemesanan.latitude!,
                                    longitude: _currentPemesanan.longitude!,
                                    customerName: _currentPemesanan.pelanggan?.name,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.map, color: Colors.white),
                            label: Text(
                              'Lihat Lokasi Pelanggan di Peta',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
