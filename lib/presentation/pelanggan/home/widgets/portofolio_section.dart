import 'dart:developer'; // Import for logging

import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_response_model.dart';
import 'package:barbergo_mobile/data/model/response/jadwal/get_all_jadwal_response_model.dart';
import 'package:barbergo_mobile/data/model/response/portofolios/get_all_portofolios_response_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioSection extends StatelessWidget {
  final bool isLoadingPortofolios;
  final List<PortofolioDatum> portfolios;
  final List<JadwalDatum> barberScheduleList;
  final List<AdminDatum> barbersList;

  const PortfolioSection({
    super.key,
    required this.isLoadingPortofolios,
    required this.portfolios,
    required this.barberScheduleList,
    required this.barbersList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portofolio Barber',
                style: GoogleFonts.amarante(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman semua portofolio
                  log('Lihat Semua Portofolio ditekan');
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => AllPortfoliosScreen()));
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal.shade700,
                ),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        isLoadingPortofolios
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: Colors.teal),
                ),
              )
            : portfolios.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                      'Tidak ada portofolio gambar hasil barber tersedia.',
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(
                    height: 330, // Increased height to accommodate a larger image and content
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: portfolios.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemBuilder: (context, index) {
                        final portfolio = portfolios[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: _buildPortfolioImageCard(
                            portfolio,
                            barberScheduleList,
                            barbersList,
                            context,
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }

  Widget _buildPortfolioImageCard(
    PortofolioDatum portfolio,
    List<JadwalDatum> allBarberSchedules,
    List<AdminDatum> allBarbers,
    BuildContext context,
  ) {
    log('--- Building Portfolio Image Card for Portfolio ID: ${portfolio.id} ---');
    log('Image URL: ${portfolio.image}');
    log('Description: ${portfolio.description}');
    log('Barber Name from Portfolio: ${portfolio.barber?.name}');

    final AdminDatum? actualBarber = allBarbers.firstWhere(
      (barber) => barber.userId == portfolio.barber?.id,
      orElse: () {
        log('WARNING: AdminDatum not found for barber ID: ${portfolio.barber?.id}');
        return AdminDatum(); // Return a default/empty AdminDatum instance
      },
    );

    log('Found actual Barber (AdminDatum): ${actualBarber?.name ?? "Not Found"}');
    log('Actual Barber Address: ${actualBarber?.alamat ?? "N/A"}');

    // Filter jadwal (though not displayed in card, this logic might be useful elsewhere)
    final relevantSchedules = allBarberSchedules
        .where((schedule) => schedule.barberId == portfolio.barber?.id)
        .toList();

    log('Filtered schedules for ${portfolio.barber?.name ?? "Unknown Barber"} (ID: ${portfolio.barber?.id}): ${relevantSchedules.length} schedules found.');

    final double cardWidth = MediaQuery.of(context).size.width * 0.75; // Slightly increased card width
    final double imageHeight = 180; // Increased image height from 150 to 180

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Portofolio
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: (portfolio.image != null && portfolio.image!.isNotEmpty)
                  ? Image.network(
                      portfolio.image!,
                      width: double.infinity,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: imageHeight,
                          color: const Color.fromARGB(255, 126, 189, 208),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        log('Error loading image for portfolio ID ${portfolio.id}. URL: ${portfolio.image}. Error: $error');
                        return Container(
                          height: imageHeight,
                          color: const Color.fromARGB(255, 125, 195, 200),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                SizedBox(height: 8),
                                Text('Gagal memuat gambar', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: imageHeight,
                      color: const Color.fromARGB(255, 156, 193, 199),
                      child: const Center(
                        child: Text('Gambar tidak tersedia', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deskripsi Portofolio with Icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.cut, size: 18, color: AppColors.secondary), // Haircut icon
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          portfolio.description ?? 'Deskripsi tidak tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Info Barber with Icon
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        // Assuming 'name' field for barber's profile image
                        // If 'name' is indeed meant for an image URL, keep it.
                        // Otherwise, it should be `actualBarber?.name` if available
                        backgroundImage: (actualBarber?.name != null && actualBarber!.name!.isNotEmpty)
                            ? NetworkImage(actualBarber.name!) as ImageProvider
                            : null,
                        child: (actualBarber?.name == null || actualBarber!.name!.isEmpty)
                            ? Icon(Icons.person, size: 25, color: Colors.grey.shade600)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              actualBarber?.name ?? 'Nama Barber',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    actualBarber?.alamat ?? 'Alamat tidak tersedia',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}