import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/presentation/pelanggan/pembayaran/pembayaran_form_screen.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/review_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/request/review/review_request_model.dart'; // For ReviewRequestModel
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_event.dart';

class PemesananActionSection extends StatelessWidget {
  final Datum pemesanan;
  final void Function(BuildContext, String) showCancelConfirmationDialog;

  const PemesananActionSection({
    super.key,
    required this.pemesanan,
    required this.showCancelConfirmationDialog,
  });

  @override
  Widget build(BuildContext context) {
    final String? status = pemesanan.status?.toLowerCase();

    if (status == 'pending') {
      // Menampilkan kedua tombol untuk status 'pending'
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final double amountToPay =
                  double.tryParse(pemesanan.totalPrice.toString()) ?? 0.0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PembayaranFormScreen(
                        pemesananId: pemesanan.id!,
                        totalAmount: amountToPay,
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              elevation: 5,
            ),
            child: Text(
              'Lanjutkan Pembayaran',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10), // Spasi antar tombol
          ElevatedButton(
            onPressed: () {
              showCancelConfirmationDialog(context, pemesanan.id.toString());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              elevation: 5,
            ),
            child: Text(
              'Batalkan Pesanan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else if (status == 'in_progress') {
      // Hanya tombol 'Batalkan Pesanan' untuk status 'in_progress'
      return Center(
        child: ElevatedButton(
          onPressed: () {
            showCancelConfirmationDialog(context, pemesanan.id.toString());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            elevation: 5,
          ),
          child: Text(
            'Batalkan Pesanan',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (status == 'cancelled') {
      // Teks untuk status 'cancelled'
      return Center(
        child: Text(
          'Pemesanan ini telah dibatalkan.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (status == 'completed' || status == 'paid') {
      // Menampilkan teks dan tombol 'Beri Ulasan' untuk status 'completed' atau 'paid'
      return Column(
        children: [
          Center(
            child: Text(
              'Pemesanan ini sudah selesai dan dibayar.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return ReviewFormDialog(
                    pemesananId: pemesanan.id!,
                    onReviewSubmitted: (rating, reviewText) {
                      // Convert double rating to int
                      final int intRating =
                          rating
                              .round(); // Or rating.toInt() if you prefer truncation

                      dialogContext.read<ReviewBloc>().add(
                        CreateReviewEvent(
                          pemesananId: pemesanan.id!,
                          requestModel: ReviewRequestModel(
                            rating: intRating, // <--- Apply the conversion here
                            review: reviewText,
                          ),
                        ),
                      );
                      Navigator.of(dialogContext).pop();
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              elevation: 5,
            ),
            child: Text(
              'Beri Ulasan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
    // Default: jika status tidak dikenali atau tidak ada aksi yang relevan
    return const SizedBox.shrink();
  }
}
