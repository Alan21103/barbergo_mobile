// lib/presentation/pemesanan/pemesanan_detail_screen.dart
import 'package:barbergo_mobile/presentation/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_detail_body.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_error_wigets.dart';
import 'package:flutter/material.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts untuk menggunakan font
import 'package:intl/intl.dart'; // Import intl untuk memformat angka menjadi mata uang
import 'package:flutter_bloc/flutter_bloc.dart'; // Import untuk BlocListener dan BlocBuilder


class PemesananDetailScreen extends StatefulWidget {
  final int pemesananId;

  const PemesananDetailScreen({super.key, required this.pemesananId});

  @override
  State<PemesananDetailScreen> createState() => _PemesananDetailScreenState();
}

class _PemesananDetailScreenState extends State<PemesananDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PemesananBloc>().add(
          GetPemesananDetailEvent(widget.pemesananId.toString()),
        );
  }

  // Helper function untuk mendapatkan warna status (tetap di sini)
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return const Color.fromARGB(255, 76, 142, 175);
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return AppColors.primary;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper function untuk memformat mata uang (diperbarui untuk menerima dynamic)
  String _formatCurrency(dynamic amount) { // PERBAIKAN: Mengubah tipe parameter menjadi dynamic
    if (amount == null) {
      return 'Rp 0'; // Atau 'Tidak Tersedia'
    }
    
    double? numericAmount;
    if (amount is num) { // Jika sudah berupa angka (int, double)
      numericAmount = amount.toDouble();
    } else if (amount is String) { // Jika masih berupa string
      numericAmount = double.tryParse(amount);
    }

    if (numericAmount == null) {
      return 'Format Salah';
    }

    try {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0, // Tidak ada digit desimal untuk Rupiah
      );
      final formattedAmount = formatter.format(numericAmount);
      return formattedAmount;
    } catch (e) {
      return 'Format Salah';
    }
  }

  // Dialog konfirmasi pembatalan (tetap di sini)
  void _showCancelConfirmationDialog(BuildContext context, String pemesananId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Konfirmasi Pembatalan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin membatalkan pesanan ini?',
            style: GoogleFonts.poppins(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Tidak',
                style: GoogleFonts.poppins(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ya, Batalkan',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<PemesananBloc>().add(
                      CancelPemesananEvent(pemesananId),
                    );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pemesanan',
          style: GoogleFonts.amarante(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: BlocConsumer<PemesananBloc, PemesananState>(
          listener: (context, state) {
            if (state is PemesananCancelSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              // Setelah sukses membatalkan, muat ulang detail pemesanan
              context.read<PemesananBloc>().add(
                    GetPemesananDetailEvent(widget.pemesananId.toString()),
                  );
            } else if (state is PemesananCancelErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            } else if (state is PemesananDetailErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PemesananDetailLoadingState) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is PemesananDetailLoadedState) {
              return PemesananDetailBody(
                profile: state.profile.data,
                pemesanan: state.pemesananDetail,
                getStatusColor: _getStatusColor,
                formatCurrency: _formatCurrency, // Menggunakan fungsi yang sudah diperbarui
                showCancelConfirmationDialog: _showCancelConfirmationDialog,
              );
            } else if (state is PemesananDetailErrorState) {
              return PemesananErrorWidget(
                errorMessage: state.error,
                onRetry: () {
                  context.read<PemesananBloc>().add(
                        GetPemesananDetailEvent(widget.pemesananId.toString()),
                      );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
