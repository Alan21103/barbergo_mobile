import 'package:barbergo_mobile/presentation/pelanggan/home/pelanggan_home_screen.dart';
import 'package:barbergo_mobile/presentation/pelanggan/pembayaran/pembayaran_screen.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/pelanggan_profile_screen.dart';
import 'package:barbergo_mobile/presentation/pemesanan/pemesanan_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors Anda

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex; // Ini akan menerima indeks yang aktif dari luar
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
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
                icon: Icon(Icons.receipt_long),
                label: 'Pemesanan',
              ),
              BottomNavigationBarItem( // Index 2
                icon: Icon(Icons.payment),
                label: 'Pembayaran',
              ),
              BottomNavigationBarItem( // Index 3
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: selectedIndex, // Gunakan selectedIndex dari properti
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              onItemTapped(index); // Panggil callback untuk memperbarui state di induk

              // Tindakan navigasi berdasarkan item yang dipilih
              // Gunakan pushReplacement agar tidak menumpuk halaman di stack navigasi
              switch (index) {
                case 0: // Beranda
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PelangganHomeScreen()),
                  );
                  break;
                case 1: // Pemesanan
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PemesananListScreen()),
                  );
                  break;
                case 2: // Pembayaran
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PembayaranListScreen()),
                  );
                  break;
                case 3: // Profil
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PelangganProfileScreen()),
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