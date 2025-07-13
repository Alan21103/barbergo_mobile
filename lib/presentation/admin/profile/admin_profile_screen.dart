import 'package:barbergo_mobile/core/components/navigation_bar_admin.dart';
import 'package:barbergo_mobile/presentation/Admin/Admin_home_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_barber_schedule_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_portofolio_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_service_screen.dart';
import 'package:barbergo_mobile/presentation/admin/profile/widgets/profile_admin_form.dart';
import 'package:barbergo_mobile/presentation/admin/profile/widgets/profile_admin_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/presentation/admin/profile/bloc/profile_admin_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  int _selectedIndex = 4; // Set default index ke 'Profile' (index 4)

  @override
  void initState() {
    super.initState();
    // Ambil profil admin saat halaman dimuat
    context.read<ProfileAdminBloc>().add(GetProfileAdminEvent());
  }

  // Fungsi untuk menangani pemilihan item pada BottomNavigationBar
  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Jika item yang sama diklik, tidak perlu navigasi ulang
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Tindakan navigasi berdasarkan item yang dipilih
    switch (index) {
      case 0: // Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          (route) => false,
        );
        break;
      case 1: // Pengelolaan Pelanggan
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminJadwalScreen()),
          (route) => false,
        );
        break;
      case 2: // Kelola Layanan
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminServiceScreen()),
          (route) => false,
        );
        break;
      case 3: // Kelola Portofolio
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminPortofolioScreen()),
          (route) => false,
        );
        break;
      case 4: // Profil Admin (saat ini)
        // Tidak perlu navigasi karena sudah di halaman ini
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Background putih untuk seluruh layar
      body: BlocListener<ProfileAdminBloc, ProfileAdminState>(
        listener: (context, state) {
          if (kDebugMode) {
            print("Current state: $state");
          }

          if (state is ProfileAdminAdded) {
            // Setelah profil berhasil ditambahkan, muat ulang profil
            context.read<ProfileAdminBloc>().add(GetProfileAdminEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profil admin berhasil ditambahkan")),
            );
          }

          if (state is ProfileAdminAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            // Top wave background
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180, // Sesuaikan tinggi wave jika perlu
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Content di atas wave dan Safe Area
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0), // Padding di atas untuk judul
                    child: Text(
                      'Profil Admin',
                      style: GoogleFonts.amarante(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ProfileAdminBloc, ProfileAdminState>(
                      builder: (context, state) {
                        if (state is ProfileAdminLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                        }

                        if (state is ProfileAdminLoaded) {
                          if (kDebugMode) {
                            print("STATE LOADED: ${state.profile}");
                          }

                          if (state.profile.data != null) {
                            // Jika data profil ada, tampilkan ProfileViewAdmin
                            return ProfileViewAdmin(profile: state.profile.data!);
                          } else {
                            // Jika data profil kosong, tampilkan form input
                            return const ProfileAdminInputForm();
                          }
                        }

                        // Default jika state bukan Loaded atau Loading (misal: Initial)
                        return const ProfileAdminInputForm();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar dipanggil sekali di sini
      bottomNavigationBar: CustomAdminBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Pastikan WaveClipper ada di core/components/wave_clipper.dart atau di sini
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom left
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40); // Curve to top right
    path.lineTo(size.width, 0); // Line to top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}