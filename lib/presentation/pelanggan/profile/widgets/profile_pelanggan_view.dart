import 'package:flutter/material.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors Anda
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/presentation/auth/login/login_screen.dart'; // Untuk navigasi logout

// Ini sekarang menjadi StatelessWidget karena tidak ada state lokal
class ProfileViewPelanggan extends StatelessWidget {
  final Data profile; // Data profil diterima dari widget induk
  const ProfileViewPelanggan({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Menghapus BlocListener PemesananBloc dari sini
    // Karena ProfileViewPelanggan hanya bertanggung jawab menampilkan profil

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: profile.photo != null && profile.photo!.isNotEmpty
                  ? Image.network(
                      profile.photo!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 150,
                          color: Colors.grey.shade300,
                        );
                      },
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.grey.shade300,
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              profile.name ?? "Nama Tidak Tersedia",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.phone ?? "No Telepon Tidak Tersedia",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black54,
              ),
            ),
            Text(
              profile.address ?? "Alamat Tidak Tersedia",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Bagian untuk "Pesanan" dan "Pengaturan"
            Column(
              children: [
                ListTile(
                  tileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () {
                    // Tindakan navigasi ke halaman Pemesanan
                    // Karena navigasi BottomNavBar sudah dihandle,
                    // Anda bisa langsung memicu perpindahan tab jika perlu,
                    // atau navigasi langsung jika ini halaman yang berbeda.
                    // Jika Anda ingin meniru klik di BottomNavbar, Anda perlu mengaksesnya dari atas.
                    // Untuk saat ini, saya hanya akan print.
                    print("Navigasi ke Pesanan List");
                    // Contoh navigasi langsung:
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PemesananListScreen()));
                  },
                  title: const Text('Pesanan'),
                  leading: Icon(
                    Icons.shopping_basket,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8), // Spasi antar ListTile
                ListTile(
                  tileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () {
                    // Aksi untuk Pengaturan
                    print("Navigasi ke Pengaturan");
                  },
                  title: const Text('Pengaturan'),
                  leading: Icon(
                    Icons.settings,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Aksi untuk keluar
                print("Logout action triggered");
                // Navigasi ke halaman login dan hapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (Route<dynamic> route) => false, // Ini akan menghapus semua rute di stack
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}