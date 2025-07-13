// lib/presentation/pemesanan/detail/widgets/pemesanan_detail_row.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PemesananDetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final TextStyle? valueStyle; // NEW: Tambahkan parameter ini

  const PemesananDetailRow({
    super.key,
    required this.label,
    this.value,
    this.valueStyle, // NEW: Inisialisasi di konstruktor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              // NEW: Gunakan valueStyle jika disediakan, jika tidak gunakan style default
              style: valueStyle ?? GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end, // Agar nilai rata kanan
            ),
          ),
        ],
      ),
    );
  }
}
