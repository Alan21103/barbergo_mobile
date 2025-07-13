import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_pembayaran_response_model.dart';

// Bloc, event, dan state
import 'package:barbergo_mobile/presentation/admin/pembayaran/bloc/admin_pembayaran_bloc.dart';

class AdminPembayaranScreen extends StatefulWidget {
  const AdminPembayaranScreen({super.key});

  @override
  State<AdminPembayaranScreen> createState() => _AdminPembayaranScreenState();
}

class _AdminPembayaranScreenState extends State<AdminPembayaranScreen> {
  final List<String> _statusOptions = ['pending', 'paid', 'failed'];

  @override
  void initState() {
    super.initState();
    context.read<AdminPembayaranBloc>().add(const GetAdminPembayaranListEvent());
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'paid':
        return AppColors.secondary;
      case 'failed':
        return Colors.red[700]!;
      default:
        return Colors.grey.shade600;
    }
  }

  void _showUpdateStatusDialog(PembayaranData pembayaran) {
    String selectedStatus = pembayaran.status ?? 'pending';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Ubah Status Pembayaran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                labelText: 'Pilih Status',
                labelStyle: GoogleFonts.poppins(color: AppColors.grey),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.poppins(color: _getStatusColor(status)),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.grey,
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (pembayaran.id != null) {
                context.read<AdminPembayaranBloc>().add(
                      UpdatePembayaranStatusEvent(id: pembayaran.id!, status: selectedStatus),
                    );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID Pembayaran tidak tersedia.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          // Background wave
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

          // Foreground content
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
                          'Kelola Pembayaran',
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
                Expanded(child: _buildPembayaranBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPembayaranBody() {
    return BlocConsumer<AdminPembayaranBloc, AdminPembayaranState>(
      listener: (context, state) {
        if (state is AdminPembayaranError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        } else if (state is AdminPembayaranActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AdminPembayaranActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${state.error}')));
        }
      },
      builder: (context, state) {
        if (state is AdminPembayaranLoading || state is AdminPembayaranUpdating) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is AdminPembayaranLoaded) {
          final pembayaranList = state.pembayaranList;
          if (pembayaranList.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data pembayaran.',
                style: GoogleFonts.poppins(color: AppColors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pembayaranList.length,
            itemBuilder: (context, index) {
              return _buildPaymentCard(context, pembayaranList[index]);
            },
          );
        }
        return Center(
          child: Text(
            'Memuat data pembayaran...',
            style: GoogleFonts.poppins(color: AppColors.grey, fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.grey),
          const SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, PembayaranData pembayaran) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(pembayaran.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${pembayaran.status?.toUpperCase() ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(pembayaran.status),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: #${pembayaran.id ?? 'N/A'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1, color: AppColors.light),
            _buildInfoRow(
              icon: Icons.attach_money,
              label: 'Jumlah:',
              value: 'Rp ${pembayaran.amount ?? '0.00'}',
              valueColor: AppColors.primary,
            ),
            _buildInfoRow(
              icon: Icons.credit_card_outlined,
              label: 'Via:',
              value: pembayaran.via ?? 'N/A',
            ),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Dibayar Pada:',
              value: pembayaran.paidAt != null
                  ? '${pembayaran.paidAt!.day}/${pembayaran.paidAt!.month}/${pembayaran.paidAt!.year} '
                    '${pembayaran.paidAt!.hour}:${pembayaran.paidAt!.minute.toString().padLeft(2, '0')}'
                  : 'N/A',
            ),
            _buildInfoRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'Pemesanan ID:',
              value: pembayaran.pemesananId?.toString() ?? 'N/A',
            ),
            _buildInfoRow(
              icon: Icons.info_outline,
              label: 'Status Pemesanan:',
              value: pembayaran.pemesanan?.status ?? 'N/A',
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateStatusDialog(pembayaran),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  'Ubah Status',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WaveClipper untuk header
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
