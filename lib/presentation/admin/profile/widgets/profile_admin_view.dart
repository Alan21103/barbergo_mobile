// lib/presentation/admin/profile/widgets/profile_admin_view.dart
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:barbergo_mobile/data/model/response/admin/admin_profile_response_model.dart'; // Model untuk admin profile
import 'package:google_fonts/google_fonts.dart'; // Google Fonts をインポート

class ProfileViewAdmin extends StatelessWidget {
  final Data profile;

  const ProfileViewAdmin({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 120,
                  color: Colors.grey.shade400,
                ),
                // ここにアバター画像を追加することもできます
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Informasi Akun',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person_outline, color: AppColors.primary),
            title: Text(
              profile.name?.isNotEmpty == true ? profile.name! : "Nama Tidak Tersedia",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            title: Text(
              profile.alamat?.isNotEmpty == true ? profile.alamat! : "Alamat Tidak Tersedia",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pengaturan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.people_outline, color: AppColors.primary),
                  title: Text('Pengelolaan Pelanggan', style: GoogleFonts.poppins()),
                  onTap: () {
                    print("Navigasi ke Pengelolaan Pelanggan dari Profile View");
                    // ここで顧客管理画面への遷移処理を実装
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
                ),
                const Divider(height: 1, color: AppColors.light),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
                  title: Text('Pengaturan', style: GoogleFonts.poppins()),
                  onTap: () {
                    print("Navigasi ke Pengaturan Admin dari Profile View");
                    // ここで管理者設定画面への遷移処理を実装
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // ログアウト処理を実装
                print("Logout Admin dari Profile View");
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                'Keluar',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}