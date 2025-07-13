import 'package:barbergo_mobile/presentation/admin/admin_barber_schedule_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_portofolio_screen.dart';
import 'package:barbergo_mobile/presentation/admin/admin_service_screen.dart';
import 'package:barbergo_mobile/presentation/admin/pembayaran/admin_pembayaran_list_screen.dart';
import 'package:barbergo_mobile/presentation/admin/pemesanan/admin_pemesanan_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/components/navigation_bar_admin.dart'; // Import CustomAdminBottomNavBar
import 'package:barbergo_mobile/core/constants/colors.dart'; // Asumsi Anda memiliki file colors.dart

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0; // Index awal untuk Home di CustomAdminBottomNavBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi ditangani oleh CustomAdminBottomNavBar itu sendiri
    // sehingga tidak perlu Navigator.pushReplacement di sini.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      extendBodyBehindAppBar: true, // Crucial: Extend body behind the AppBar
      extendBody: true, // Extend body behind the bottom navigation bar
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Wallpaper2.jpeg', // Path to your background image
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken, // Apply a darkening blend mode
              color: Colors.black.withOpacity(0.5), // Darken the image further for better text contrast
            ),
          ),
          // Main Content with Rounded Corners and AppBar content
          Column(
            children: [
              // AppBar-like section
              AppBar(
                backgroundColor: Colors.transparent, // Make AppBar background transparent
                elevation: 0, // Remove shadow
                toolbarHeight: 90, // Slightly increase AppBar height for better visual balance
                titleSpacing: 0, // Remove default title spacing
                title: Align(
                  alignment: Alignment.bottomLeft, // Align title to the bottom-left of AppBar
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 15.0), // Add left and bottom padding for the title
                    child: Text(
                      '',
                      style: GoogleFonts.amarante(
                        fontSize: 24, // Slightly increased font size for AppBar title
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // AppBar title color
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 16.0), // Align icon with the bottom of AppBar and add right padding
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 30), // Slightly larger icon
                      onPressed: () {
                        // Handle notifications
                      },
                    ),
                  ),
                ],
              ),
              // Welcome text and description section
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 25.0), // Adjusted padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, Admin!',
                      style: GoogleFonts.amarante(
                        fontSize: 26, // Increased font size
                        fontWeight: FontWeight.w700,
                        color: Colors.white, // Text color for welcome message
                      ),
                    ),
                    const SizedBox(height: 10), // Increased spacing
                    Text(
                      'Kelola aplikasi barber Anda dengan mudah dan efisien dari sini.', // More descriptive
                      style: GoogleFonts.poppins(
                        fontSize: 16, // Increased font size
                        color: Colors.white70, // Text color for description
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded section for the white content area with GridView
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255), // Content background color
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0), // More rounded top-left corner
                      topRight: Radius.circular(35.0), // More rounded top-right corner
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Slightly more pronounced shadow
                        spreadRadius: 6,
                        blurRadius: 15,
                        offset: const Offset(0, -5), // Shadow at the top
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Increased padding
                    child: GridView.count(
                      crossAxisCount: 2, // 2 kolom
                      crossAxisSpacing: 25, // Increased spacing between columns
                      mainAxisSpacing: 25, // Increased spacing between rows
                      children: [
                        _buildDashboardCard(
                          context,
                          icon: Icons.cut,
                          title: 'Layanan',
                          description: 'Kelola daftar layanan barber Anda.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminServiceScreen()),
                            );
                          },
                        ),
                        _buildDashboardCard(
                          context,
                          icon: Icons.calendar_today,
                          title: 'Jadwal',
                          description: 'Atur ketersediaan jadwal barber.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminJadwalScreen()),
                            );
                          },
                        ),
                        _buildDashboardCard(
                          context,
                          icon: Icons.photo_library,
                          title: 'Portofolio',
                          description: 'Pamerkan hasil karya terbaik Anda.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminPortofolioScreen()),
                            );
                          },
                        ),
                        _buildDashboardCard(
                          context,
                          icon: Icons.receipt_long, // Icon baru untuk pemesanan
                          title: 'Pemesanan',
                          description: 'Lihat dan kelola semua pemesanan.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminPemesananScreen()), // Navigasi ke AdminPemesananScreen
                            );
                          },
                        ),
                        _buildDashboardCard( // Kartu baru untuk Pembayaran
                          context,
                          icon: Icons.payment, // Icon untuk pembayaran
                          title: 'Pembayaran',
                          description: 'Lihat dan kelola semua transaksi pembayaran.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminPembayaranScreen()), // Navigasi ke AdminPembayaranScreen
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomAdminBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 6, // Increased elevation for more depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners for cards
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5), // Slightly more prominent border
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: AppColors.primary.withOpacity(0.1), // Add a splash color for tap feedback
        highlightColor: AppColors.primary.withOpacity(0.05), // Add a highlight color
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increased padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 35, // Larger icons for better visibility
                color: AppColors.primary,
              ),
              const SizedBox(height: 12), // Increased spacing
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15, // Increased title font for cards
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6), // Increased spacing
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12, // Increased description font for cards
                  color: Colors.grey.shade700, // Slightly darker grey for better readability
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}