// lib/presentation/pemesanan/detail/widgets/pemesanan_summary_card.dart
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart'; // Pastikan Datum diimpor dari sini
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_detail_row.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PemesananSummaryCard extends StatelessWidget {
  final Datum pemesanan;
  final Data profile;
  final Color Function(String?) getStatusColor;
  final String Function(dynamic) formatCurrency; // Mengubah tipe parameter menjadi dynamic

  const PemesananSummaryCard({
    super.key,
    required this.pemesanan,
    required this.getStatusColor,
    required this.formatCurrency, 
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Mengurangi padding keseluruhan dari 20.0 menjadi 16.0
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row( // NEW: Row untuk ikon dan judul
                  children: [
                    Icon(Icons.receipt_long, color: AppColors.primary, size: 24), // Ikon baru
                    const SizedBox(width: 8), // Spasi antara ikon dan teks
                    Text(
                      'Pemesanan #${pemesanan.id ?? 'N/A'}',
                      style: GoogleFonts.poppins(
                        fontSize: 20, // Mengurangi ukuran font sedikit
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, // Mengurangi padding horizontal
                    vertical: 5,    // Mengurangi padding vertical
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(pemesanan.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: getStatusColor(pemesanan.status),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    pemesanan.status?.toUpperCase() ?? 'N/A',
                    style: GoogleFonts.poppins(
                      fontSize: 13, // Mengurangi ukuran font sedikit
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(pemesanan.status),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 25, // Mengurangi tinggi divider
              thickness: 1,
            ),

            PemesananDetailSection(
              title: 'Detail Layanan',
              children: [
                PemesananDetailRow(
                  label: 'Layanan',
                  value: pemesanan.service?.name,
                ),
                PemesananDetailRow(
                  label: 'Harga Layanan',
                  value: formatCurrency(pemesanan.service?.price),
                ),
              ],
            ),
            const SizedBox(height: 15), // Mengurangi SizedBox height

            PemesananDetailSection(
              title: 'Detail Barber & Pelanggan',
              children: [
                PemesananDetailRow(
                  label: 'Nama Barber',
                  value: pemesanan.barber?.name,
                ),
                PemesananDetailRow(
                  label: 'Nama Pelanggan',
                  value: profile.name
                ),
              ],
            ),
            const SizedBox(height: 15), // Mengurangi SizedBox height

            PemesananDetailSection(
              title: 'Informasi Waktu & Lokasi',
              children: [
                PemesananDetailRow(
                  label: 'Jadwal',
                  value: pemesanan.scheduledTime != null
                      ? DateFormat(
                              'EEEE, dd MMMM yyyy HH:mm',
                              'id_ID',
                            ).format(
                              pemesanan.scheduledTime!.toLocal(),
                            )
                      : 'N/A',
                ),
                PemesananDetailRow(
                  label: 'Alamat',
                  value: pemesanan.alamat,
                ),
                PemesananDetailRow(
                  label: 'Ongkir',
                  value: formatCurrency(pemesanan.ongkir),
                ),
              ],
            ),
            const SizedBox(height: 15), // Mengurangi SizedBox height

            PemesananDetailSection(
              title: 'Total Pembayaran',
              children: [
                PemesananDetailRow(
                  label: 'Total',
                  value: formatCurrency(pemesanan.totalPrice),
                  valueStyle: GoogleFonts.poppins(
                    fontSize: 18, // Mengurangi ukuran font sedikit
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
