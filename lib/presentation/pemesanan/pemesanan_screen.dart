// lib/presentation/pemesanan/pemesanan_list_screen.dart

import 'package:barbergo_mobile/core/components/custom_navbar.dart';
import 'package:barbergo_mobile/presentation/pemesanan/widgets/pemesanan_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/core/core.dart'; // Import AppColors
import 'package:barbergo_mobile/presentation/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/pemesanan/widgets/pemesanan_content.dart';
import 'package:barbergo_mobile/presentation/pemesanan/pemesanan_form_screen.dart'; // ASUMSI: Anda punya screen form pesanan baru

class PemesananListScreen extends StatefulWidget {
  const PemesananListScreen({super.key});

  @override
  State<PemesananListScreen> createState() => _PemesananListScreenState();
}

class _PemesananListScreenState extends State<PemesananListScreen> {
  int _selectedIndex = 1; // Index 1 for the 'Pemesanan' tab
  String _selectedFilter = 'all'; // Filter state: 'all', 'pending', 'in_progress', 'completed', 'cancelled'

  @override
  void initState() {
    super.initState();
    _fetchPemesananList(); // Fetch function on init
  }

  void _fetchPemesananList() {
    print("Dispatching GetPemesananListEvent from PemesananListScreen...");
    context.read<PemesananBloc>().add(GetPemesananListEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implement navigation if necessary (e.g., for home/profile tabs)
    // if (index == 0) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // } else if (index == 2) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    // }
  }

  void _onFilterSelected(String filterKey) {
    setState(() {
      _selectedFilter = filterKey;
    });
  }

  // Fungsi untuk menangani navigasi ke halaman tambah pesanan baru
  void _onAddPemesananTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // ASUMSI: Anda memiliki PemesananFormScreen atau nama serupa
        // Ganti dengan nama screen form pesanan Anda yang sebenarnya
        builder: (context) => const PemesananFormScreen(),
      ),
    ).then((_) {
      // Opsional: Reload daftar setelah kembali dari form (jika ada data baru ditambahkan)
      _fetchPemesananList();
    });
  }

  @override
  Widget build(BuildContext
      context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pemesanan',
          style: GoogleFonts.amarante(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menggunakan widget yang sudah dipecah
            PemesananFilterButtons(
              selectedFilter: _selectedFilter,
              onFilterSelected: _onFilterSelected,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row( // <-- Menggunakan Row untuk menempatkan teks dan ikon sejajar
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // <-- Agar item terpisah
                children: [
                  Text(
                    'Pemesanan Terbaru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: AppColors.primary, size: 28), // Ikon tambah
                    onPressed: _onAddPemesananTapped, // Panggil fungsi saat ditekan
                    tooltip: 'Tambah Pemesanan Baru', // Tooltip untuk aksesibilitas
                  ),
                ],
              ),
            ),
            Expanded(
              // Menggunakan widget yang sudah dipecah
              child: PemesananContent(
                selectedFilter: _selectedFilter,
                fetchListCallback: _fetchPemesananList,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}