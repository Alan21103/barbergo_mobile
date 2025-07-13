import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_pemesanan_response_model.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/admin_pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/admin/pemesanan/admin_detail_pemesanan_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/repository/admin_repository.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';

class AdminPemesananScreen extends StatefulWidget {
  const AdminPemesananScreen({super.key});

  @override
  State<AdminPemesananScreen> createState() => _AdminPemesananScreenState();
}

class _AdminPemesananScreenState extends State<AdminPemesananScreen> {
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

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AdminPemesananBloc>().add(const GetAdminPemesananListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Kelola Pemesanan',
                          style: GoogleFonts.amarante(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildPemesananBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPemesananBody() {
    return BlocProvider(
      create: (context) => AdminPemesananBloc(adminRepository: AdminRepository(ServiceHttpClient()))
        ..add(const GetAdminPemesananListEvent()),
      child: BlocConsumer<AdminPemesananBloc, AdminPemesananState>(
        listener: (context, state) {
          if (state is AdminPemesananError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error memuat pemesanan: ${state.message}')),
            );
          } else if (state is AdminPemesananActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AdminPemesananActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminPemesananLoading || state is AdminPemesananUpdating) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is AdminPemesananLoaded) {
            final pemesananList = state.pemesananList;
            if (pemesananList.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada pemesanan yang tersedia.',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: pemesananList.length,
              itemBuilder: (context, index) {
                final pemesanan = pemesananList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${pemesanan.status ?? 'N/A'}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(pemesanan.status),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Pelanggan:',
                          value: pemesanan.pelanggan?.name ?? 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.cut,
                          label: 'Barber:',
                          value: pemesanan.barber?.name ?? 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.content_cut,
                          label: 'Layanan:',
                          value: pemesanan.service?.name ?? 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.schedule,
                          label: 'Waktu:',
                          value: pemesanan.scheduledTime != null
                              ? '${pemesanan.scheduledTime!.day}/${pemesanan.scheduledTime!.month}/${pemesanan.scheduledTime!.year} ${pemesanan.scheduledTime!.hour}:${pemesanan.scheduledTime!.minute.toString().padLeft(2, '0')}'
                              : 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.location_on,
                          label: 'Alamat:',
                          value: pemesanan.alamat ?? 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.delivery_dining,
                          label: 'Ongkir:',
                          value: 'Rp ${pemesanan.ongkir ?? '0'}',
                        ),
                        _buildInfoRow(
                          icon: Icons.attach_money,
                          label: 'Total Harga:',
                          value: 'Rp ${pemesanan.totalPrice ?? '0'}',
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminDetailPemesananScreen(pemesanan: pemesanan),
                                ),
                              );

                              if (result != null && result is bool && result == true) {
                                context.read<AdminPemesananBloc>().add(const GetAdminPemesananListEvent());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Lihat Detail & Ubah Status',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text(
              'Memuat data pemesanan...',
              style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}

// Tambahkan di akhir file
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
