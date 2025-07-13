import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/widgets/profile_pelanggan_form.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/widgets/profile_pelanggan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/core/components/custom_navbar.dart'; // Import CustomBottomNavBar
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart'; // Untuk model Data profil

class PelangganProfileScreen extends StatefulWidget {
  const PelangganProfileScreen({super.key});

  @override
  State<PelangganProfileScreen> createState() => _PelangganProfileScreenState();
}

class _PelangganProfileScreenState extends State<PelangganProfileScreen> {
  // Tambahkan state untuk mengelola indeks Bottom Navigation Bar
  // Indeks 3 adalah untuk 'Profil' di CustomBottomNavBar (Beranda=0, Pemesanan=1, Pembayaran=2, Profil=3)
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    // Ambil profil pembeli saat halaman dimuat
    context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
  }

  // Callback untuk CustomBottomNavBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi sebenarnya ditangani di dalam CustomBottomNavBar itu sendiri
    // menggunakan Navigator.pushReplacement.
    // Jadi, di sini kita hanya perlu memperbarui _selectedIndex.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // Hapus leading IconButton jika ini adalah salah satu tab utama.
        // Jika Anda tetap ingin ada tombol kembali, pertimbangkan logikanya
        // agar tidak mempop-out aplikasi.
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ProfilePelangganBloc, ProfilePelangganState>(
        listener: (context, state) {
          // Log state saat terjadi perubahan
          print("Current state: $state");

          if (state is ProfilePelangganAdded) {
            // Refresh profil setelah berhasil ditambahkan
            context.read<ProfilePelangganBloc>().add(GetProfilePelangganEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profil berhasil ditambahkan")),
            );
          }

          // Menangani error jika profil sudah ada
          if (state is ProfilePelangganAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)), // Menampilkan error message
            );
          }
        },
        child: BlocBuilder<ProfilePelangganBloc, ProfilePelangganState>(
          builder: (context, state) {
            if (state is ProfilePelangganLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Jika profil pelanggan sudah ada, tampilkan profil
            if (state is ProfilePelangganLoaded &&
                state.profile.data?.name != null &&
                state.profile.data!.name!.isNotEmpty) {
              final Data profile = state.profile.data!; // Pastikan tipe Data sesuai
              print("STATE LOADED: ${state.profile.data}");
              return ProfileViewPelanggan(profile: profile);
            }

            // Jika profil belum ada atau error (atau tidak ada data), tampilkan form input
            return ProfilePelangganInputForm();
          },
        ),
      ),
      // Tambahkan CustomBottomNavBar di sini
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}