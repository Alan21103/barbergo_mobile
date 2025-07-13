// lib/presentation/pemesanan/widgets/pemesanan_filter_buttons.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors

class PemesananFilterButtons extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const PemesananFilterButtons({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  // Fungsi helper untuk mendapatkan ikon berdasarkan filterKey
  IconData _getFilterIcon(String filterKey) {
    switch (filterKey) {
      case 'all':
        return Icons.list; // Atau ikon lain yang sesuai
      case 'pending':
        return Icons.access_time;
      case 'in_progress':
        return Icons.play_arrow; // Atau ikon lain yang sesuai
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'paid': // NEW: Icon for 'paid' status
        return Icons.payments; // Atau ikon lain yang sesuai, misalnya Icons.attach_money
      default:
        return Icons.filter_list;
    }
  }

  Widget _buildFilterButton(String filterKey, String label) {
    final bool isSelected = selectedFilter == filterKey;
    final Color textColor = isSelected ? Colors.white : Colors.black87;
    final Color iconColor = isSelected ? Colors.white : Colors.grey[700]!;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFilterIcon(filterKey),
              size: 18,
              color: iconColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(color: textColor),
            ),
          ],
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey[200],
        onSelected: (selected) {
          if (selected) {
            onFilterSelected(filterKey);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Row(
            children: [
              _buildFilterButton('all', 'Semua'),
              _buildFilterButton('pending', 'Pending'),
              _buildFilterButton('in_progress', 'Berjalan'),
              _buildFilterButton('completed', 'Selesai'),
              _buildFilterButton('paid', 'Dibayar'), // NEW: Add 'paid' filter button
              _buildFilterButton('cancelled', 'Dibatalkan'),
            ],
          ),
        ),
      ),
    );
  }
}
