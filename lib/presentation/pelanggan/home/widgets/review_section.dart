import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/review/get_all_review_response_model.dart';
import 'package:intl/intl.dart';

class ReviewsSection extends StatelessWidget {
  final bool isLoading;
  final List<ReviewDatum> reviewList;

  const ReviewsSection({
    super.key,
    required this.isLoading,
    required this.reviewList,
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
                'Ulasan Pelanggan',
                style: GoogleFonts.amarante(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman semua ulasan
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
            : reviewList.isEmpty
                ? Text(
                    'Belum ada ulasan tersedia.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reviewList.length,
                    itemBuilder: (context, index) {
                      final review = reviewList[index];
                      return _buildReviewCard(review);
                    },
                  ),
      ],
    );
  }

  Widget _buildReviewCard(ReviewDatum review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
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
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pengguna #${review.pemesananId ?? 'N/A'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review.rating ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.review ?? 'Tidak ada ulasan.',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (review.deskripsi != null && review.deskripsi!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Deskripsi: ${review.deskripsi}',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              review.createdAt != null
                  ? DateFormat('dd MMM yyyy').format(review.createdAt!)
                  : 'Tanggal Tidak Diketahui',
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
