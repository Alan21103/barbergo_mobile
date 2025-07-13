// lib/presentation/pemesanan/widgets/pemesanan_list_item.dart

import 'package:barbergo_mobile/presentation/pemesanan/utils/pemesanan_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';

class PemesananListItem extends StatelessWidget {
  final Datum pemesananItem;
  final VoidCallback onTap;

  const PemesananListItem({
    super.key,
    required this.pemesananItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: PemesananUtils.getStatusColor(pemesananItem.status).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PemesananUtils.getIconForPemesanan(pemesananItem.status, pemesananItem.service?.name),
                  color: PemesananUtils.getStatusColor(pemesananItem.status),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pemesananItem.service?.name ?? 'Layanan Tidak Diketahui',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Barber: ${pemesananItem.barber?.name ?? 'N/A'}',
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
                    PemesananUtils.formatCurrency(pemesananItem.service?.price.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: PemesananUtils.getStatusColor(pemesananItem.status),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pemesananItem.scheduledTime != null
                        ? PemesananUtils.formatDate(pemesananItem.scheduledTime!)
                        : 'N/A',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
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