import 'package:barbergo_mobile/presentation/pemesanan/pemesanan_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:intl/intl.dart';

class JadwalSection extends StatelessWidget {
  final bool isLoading;
  final List<Datum> jadwalList;

  const JadwalSection({
    super.key,
    required this.isLoading,
    required this.jadwalList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jadwal Anda',
                style: GoogleFonts.amarante(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman semua jadwal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PemesananListScreen()),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
            : jadwalList.isEmpty
                ? Text(
                    'Tidak ada jadwal pemesanan.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  )
                : SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: jadwalList.length,
                      itemBuilder: (context, index) {
                        final jadwal = jadwalList[index];
                        return _buildJadwalCard(jadwal);
                      },
                    ),
                  ),
      ],
    );
  }

  Widget _buildJadwalCard(Datum jadwal) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jadwal.service?.name ?? 'Layanan Tidak Diketahui',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            'Barber: ${jadwal.barber?.name ?? 'Barber Tidak Diketahui'}',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Text(
            'Waktu: ${jadwal.scheduledTime != null ? DateFormat('dd MMM yyyy, HH:mm').format(jadwal.scheduledTime!) : 'N/A'}',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Chip(
              label: Text(
                jadwal.status ?? 'Pending',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: _getStatusColor(jadwal.status),
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
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
