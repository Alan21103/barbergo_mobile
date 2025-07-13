// lib/presentation/pembayaran/widgets/pembayaran_list_item.dart

import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/data/model/response/pembayaran/get_all_pembayaran_response_model.dart';
import 'package:barbergo_mobile/presentation/pemesanan/utils/pemesanan_utils.dart'; // Menggunakan PemesananUtils untuk format dan warna

class PembayaranListItem extends StatelessWidget {
  final PembayaranDatum pembayaranItem;
  final Data profile;
  final VoidCallback onTap;

  const PembayaranListItem({
    super.key,
    required this.pembayaranItem,
    required this.onTap, 
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan fungsi formatCurrency dari PemesananUtils
    final String formattedAmount = PemesananUtils.formatCurrency(pembayaranItem.amount);
    // Menggunakan fungsi getStatusColor dari PemesananUtils
    final Color statusColor = PemesananUtils.getStatusColor(pembayaranItem.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ikon status pembayaran
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.payment, // Ikon umum untuk pembayaran
                  color: statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan #${pembayaranItem.pemesananId ?? 'N/A'}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Metode: ${pembayaranItem.via?.toUpperCase() ?? 'N/A'}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pelanggan: ${profile.name ?? 'N/A'}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedAmount,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pembayaranItem.paidAt != null
                        ? PemesananUtils.formatDate(pembayaranItem.paidAt!)
                        : 'Tanggal Tidak Diketahui',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      pembayaranItem.status?.toUpperCase() ?? 'N/A',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
                    ),
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
