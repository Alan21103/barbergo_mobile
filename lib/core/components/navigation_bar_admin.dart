import 'package:barbergo_mobile/presentation/admin/admin_barber_schedule_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_home_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_portofolio_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors Anda
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

// Import your admin-specific screens
import 'package:barbergo_mobile/presentation/admin/profile/admin_profile_screen.dart';
// Anda TIDAK perlu mengimpor AdminPemesananScreen atau AdminPembayaranScreen di sini
// karena mereka tidak akan menjadi bagian langsung dari item navigasi bawah.


class CustomAdminBottomNavBar extends StatelessWidget {
  final int selectedIndex; // This will receive the active index from outside
  final Function(int) onItemTapped;

  const CustomAdminBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white, // Menggunakan warna putih dari AppColors
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Bayangan sedikit lebih gelap
              spreadRadius: 3, // Mengurangi spread radius
              blurRadius: 15, // Menambah blur radius
              offset: const Offset(0, 8), // Bayangan lebih ke bawah
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), // Menggunakan outline icon
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined), // Menggunakan outline icon
                activeIcon: Icon(Icons.calendar_today),
                label: 'Jadwal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services_outlined), // Menggunakan outline icon
                activeIcon: Icon(Icons.design_services),
                label: 'Layanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library_outlined), // Menggunakan outline icon
                activeIcon: Icon(Icons.photo_library),
                label: 'Portofolio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), // Menggunakan outline icon
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: selectedIndex, // Use selectedIndex from properties
            selectedItemColor: AppColors.primary, // Warna item yang dipilih
            unselectedItemColor: AppColors.grey, // Warna item yang tidak dipilih
            selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12), // Gaya label terpilih
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 11), // Gaya label tidak terpilih
            onTap: (index) {
              onItemTapped(index); // Call callback to update state in parent

              // Navigation actions based on the selected item
              // Use pushReplacement to avoid stacking pages on the navigation stack
              switch (index) {
                case 0: // Home
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
                  );
                  break;
                case 1: // Jadwal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminJadwalScreen()),
                  );
                  break;
                case 2: // Layanan (Service)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminServiceScreen()),
                  );
                  break;
                case 3: // Portofolio
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPortofolioScreen()),
                  );
                  break;
                case 4: // Profil
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
                  );
                  break;
              }
            },
            type: BottomNavigationBarType.fixed, // Memastikan semua item terlihat
            backgroundColor: Colors.transparent, // Latar belakang transparan untuk efek container
            elevation: 0.0, // Menghilangkan shadow default BottomNavigationBar
          ),
        ),
      ),
    );
  }
}