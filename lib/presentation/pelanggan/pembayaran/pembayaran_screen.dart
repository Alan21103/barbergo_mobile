// lib/presentation/pembayaran/pembayaran_list_screen.dart

import 'package:barbergo_mobile/core/components/custom_navbar.dart';
import 'package:barbergo_mobile/presentation/pelanggan/pembayaran/bloc/pembayaran_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/pembayaran/widgets/pembayaran_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors

// NEW: Import ProfilePelangganBloc dan modelnya
import 'package:barbergo_mobile/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart'; // Untuk Data (model profil pelanggan)

class PembayaranListScreen extends StatefulWidget {
  const PembayaranListScreen({super.key});

  @override
  State<PembayaranListScreen> createState() => _PembayaranListScreenState();
}

class _PembayaranListScreenState extends State<PembayaranListScreen> {
  int _selectedIndex = 2; // Index 2 untuk tab 'Pembayaran' di CustomBottomNavBar

  // NEW: State untuk menyimpan data profil pelanggan
  Data? _pelangganProfile;
  bool _isLoadingProfile = true;
  String? _profileError;

  @override
  void initState() {
    super.initState();
    _fetchPembayaranList(); // Memuat daftar pembayaran saat inisialisasi
    _fetchPelangganProfile(); // NEW: Memuat profil pelanggan
  }

  void _fetchPembayaranList() {
    print("Dispatching GetAllPembayaranEvent from PembayaranListScreen...");
    context.read<PembayaranBloc>().add(const GetAllPembayaranEvent());
  }

  // NEW: Fungsi untuk memuat profil pelanggan
  void _fetchPelangganProfile() {
    print("Dispatching GetProfilePelangganEvent from PembayaranListScreen...");
    context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi akan ditangani oleh CustomBottomNavBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pembayaran',
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
        child: MultiBlocListener( // Menggunakan MultiBlocListener untuk mendengarkan beberapa Bloc
          listeners: [
            BlocListener<PembayaranBloc, PembayaranState>(
              listener: (context, state) {
                if (state is PembayaranError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memuat pembayaran: ${state.error}', style: GoogleFonts.poppins()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            // NEW: Listener untuk ProfilePelangganBloc
            BlocListener<ProfilePelangganBloc, ProfilePelangganState>(
              listener: (context, state) {
                if (state is ProfilePelangganLoading) {
                  setState(() {
                    _isLoadingProfile = true;
                    _profileError = null;
                  });
                } else if (state is ProfilePelangganLoaded) {
                  setState(() {
                    _isLoadingProfile = false;
                    _pelangganProfile = state.profile.data;
                  });
                } else if (state is ProfilePelangganError) {
                  setState(() {
                    _isLoadingProfile = false;
                    _profileError = state.message;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memuat profil pelanggan: ${state.message}', style: GoogleFonts.poppins()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<PembayaranBloc, PembayaranState>( // BlocBuilder untuk PembayaranBloc
            builder: (context, pembayaranState) {
              // Menangani loading state dari kedua Bloc
              if (pembayaranState is PembayaranLoading || _isLoadingProfile) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } 
              // Menangani error state dari kedua Bloc
              else if (pembayaranState is PembayaranError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Error memuat pembayaran: ${pembayaranState.error}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchPembayaranList,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: Text('Coba Lagi', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              } else if (_profileError != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 80, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Error memuat profil pelanggan: $_profileError',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchPelangganProfile,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: Text('Coba Lagi Profil', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
              // Jika kedua Bloc berhasil memuat data
              else if (pembayaranState is PembayaranLoaded && _pelangganProfile != null) {
                final pembayaranList = pembayaranState.pembayaranList;

                if (pembayaranList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada riwayat pembayaran.',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  itemCount: pembayaranList.length,
                  itemBuilder: (context, index) {
                    final pembayaranItem = pembayaranList[index];
                    return PembayaranListItem(
                      pembayaranItem: pembayaranItem,
                      profile: _pelangganProfile!, // NEW: Meneruskan objek profil
                      onTap: () {
                        // Opsional: Navigasi ke detail pembayaran jika ada
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink(); // Default state
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
