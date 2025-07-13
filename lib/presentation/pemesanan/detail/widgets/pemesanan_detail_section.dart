// lib/presentation/pemesanan/widgets/pemesanan_detail_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/core.dart'; // Pastikan path AppColors benar

class PemesananDetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PemesananDetailSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        ...children, // Spread operator untuk menambahkan list widget
      ],
    );
  }
}