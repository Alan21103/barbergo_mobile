import 'package:barbergo_mobile/presentation/admin/admin_barber_schedule_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_home_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_portofolio_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors Anda

// Import your admin-specific screens
import 'package:barbergo_mobile/presentation/admin/profile/admin_profile_screen.dart'; // Example path


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
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), // Icon for schedule
                label: 'Jadwal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services), // Icon for service
                label: 'Layanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library), // Icon for portfolio
                label: 'Portofolio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: selectedIndex, // Use selectedIndex from properties
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
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
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
      ),
    );
  }
}