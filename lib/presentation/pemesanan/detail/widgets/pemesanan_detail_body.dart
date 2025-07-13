// lib/presentation/pemesanan/detail/widgets/pemesanan_detail_body.dart

import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_action_section.dart';
import 'package:barbergo_mobile/presentation/pemesanan/detail/widgets/pemesanan_summary_card.dart';
import 'package:flutter/material.dart';

// ignore: unused_element
class PemesananDetailBody extends StatelessWidget {
  final Datum pemesanan;
  final Data profile;
  final Color Function(String?) getStatusColor;
  final String Function(dynamic) formatCurrency; // PERBAIKAN: Mengubah tipe parameter menjadi dynamic
  final void Function(BuildContext, String) showCancelConfirmationDialog;

  const PemesananDetailBody({
    super.key,
    required this.pemesanan,
    required this.getStatusColor,
    required this.formatCurrency,
    required this.showCancelConfirmationDialog,
    required this.profile
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PemesananSummaryCard(
            pemesanan: pemesanan,
            getStatusColor: getStatusColor,
            formatCurrency: formatCurrency,
            profile: profile,
          ),
          const SizedBox(height: 30),
          PemesananActionSection(
            pemesanan: pemesanan,
            showCancelConfirmationDialog: showCancelConfirmationDialog,
          ),
        ],
      ),
    );
  }
}
