// lib/presentation/pemesanan/utils/pemesanan_utils.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk DateFormat
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors

class PemesananUtils {
  /// Mengembalikan warna yang sesuai berdasarkan status pemesanan.
  static Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return const Color.fromARGB(255, 76, 142, 175); // Warna untuk status 'paid'
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return AppColors.primary; // Menggunakan warna primary dari AppColors
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Mengembalikan ikon yang sesuai berdasarkan status pemesanan dan nama layanan.
  static IconData getIconForPemesanan(String? status, String? serviceName) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Icons.credit_card; // Ikon untuk status 'paid'
      case 'pending':
        return Icons.hourglass_empty;
      case 'in_progress':
        return Icons.build; // Atau Icons.schedule
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        // Anda bisa menambahkan logika ikon berdasarkan serviceName di sini jika diperlukan
        // Contoh: if (serviceName?.toLowerCase().contains('potong') == true) return Icons.content_cut;
        return Icons.assignment; // Ikon default
    }
  }

  /// Memformat objek DateTime menjadi string tanggal yang mudah dibaca.
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  /// Memformat angka atau string yang merepresentasikan mata uang ke format Rupiah.
  static String formatCurrency(dynamic amount) {
    if (amount == null) {
      return 'Rp 0';
    }

    double? numericAmount;
    if (amount is num) {
      numericAmount = amount.toDouble();
    } else if (amount is String) {
      numericAmount = double.tryParse(amount);
    }

    if (numericAmount == null) {
      return 'Rp Invalid'; // Mengubah 'Format Salah' menjadi 'Rp Invalid'
    }

    try {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      );
      final formattedAmount = formatter.format(numericAmount);
      return formattedAmount;
    } catch (e) {
      return 'Rp Error'; // Mengubah 'Format Salah' menjadi 'Rp Error'
    }
  }
}
