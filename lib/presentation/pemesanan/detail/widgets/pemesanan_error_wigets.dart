// lib/presentation/pemesanan/detail/widgets/pemesanan_error_widget.dart

import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: unused_element
class PemesananErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const PemesananErrorWidget({super.key, 
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat detail pemesanan:\n$errorMessage',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              'Coba Lagi',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}