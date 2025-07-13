// lib/presentation/pemesanan/widgets/pemesanan_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/core.dart'; // Import AppColors
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/presentation/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/pemesanan_detail_screen.dart';
import 'package:barbergo_mobile/presentation/pemesanan/widgets/pemesanan_list_item.dart'; // Import widget baru

class PemesananContent extends StatelessWidget {
  final String selectedFilter;
  final VoidCallback fetchListCallback;

  const PemesananContent({
    super.key,
    required this.selectedFilter,
    required this.fetchListCallback,
  });

  List<Datum> _getFilteredPemesananList(List<Datum> originalList) {
    if (selectedFilter == 'all') {
      return originalList;
    }
    return originalList.where((pemesanan) => pemesanan.status?.toLowerCase() == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PemesananBloc, PemesananState>(
      builder: (context, state) {
        if (state is PemesananLoadingState) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is PemesananLoadedState) {
          final filteredList = _getFilteredPemesananList(state.pemesananDatumList);

          if (filteredList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    state.message, // Menggunakan state.message dari backend
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final Datum pemesananItem = filteredList[index];
              return PemesananListItem( // Menggunakan widget PemesananListItem yang terpisah
                pemesananItem: pemesananItem,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PemesananDetailScreen(pemesananId: pemesananItem.id!),
                    ),
                  ).then((_) {
                    fetchListCallback(); // Reload the list after navigating back
                  });
                },
              );
            },
          );
        }

        if (state is PemesananErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.red.shade700),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchListCallback,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text('Coba Lagi', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink(); // Default state
      },
    );
  }
}