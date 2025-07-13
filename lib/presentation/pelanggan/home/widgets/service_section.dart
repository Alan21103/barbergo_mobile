import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';

class ServicesSection extends StatelessWidget {
  final bool isLoading;
  final List<GetAllServiceModel> serviceList;

  const ServicesSection({
    super.key,
    required this.isLoading,
    required this.serviceList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Layanan Kami',
            style: GoogleFonts.amarante(
              fontSize: 22, // Slightly larger font size
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary)) // Use primary color
            : serviceList.isEmpty
                ? Center( // Center the "no services" message
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Tidak ada layanan tersedia saat ini.', // More descriptive message
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: serviceList.length,
                      itemBuilder: (context, index) {
                        final service = serviceList[index];
                        return _buildServiceCard(service);
                      },
                    ),
                  ),
      ],
    );
  }

  Widget _buildServiceCard(GetAllServiceModel service) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          // Service Icon Container
          Container(
            width: 70, // Slightly larger icon container
            height: 70, // Slightly larger icon container
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15), // Slightly more opaque background
              borderRadius: BorderRadius.circular(20), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Subtle shadow for depth
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getServiceIcon(service.name), // Dynamically get icon based on service name
              color: AppColors.primary,
              size: 35, // Larger icon size
            ),
          ),
          const SizedBox(height: 10), // Increased spacing
          Text(
            service.name ?? 'Layanan',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13, // Slightly larger font for service name
              fontWeight: FontWeight.w600, // Bolder font weight
              color: Colors.grey[800], // Darker text color
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper function to get different icons based on service name (optional, but enhances UI)
  IconData _getServiceIcon(String? serviceName) {
    if (serviceName == null) return Icons.cut; // Default icon

    final lowerCaseName = serviceName.toLowerCase();
    if (lowerCaseName.contains('potong')) {
      return Icons.content_cut;
    } else if (lowerCaseName.contains('shave') || lowerCaseName.contains('cukur')) {
      return Icons.face;
    } else if (lowerCaseName.contains('cuci')) {
      return Icons.wash;
    } else if (lowerCaseName.contains('warna')) {
      return Icons.colorize;
    } else if (lowerCaseName.contains('pijat')) {
      return Icons.spa;
    }
    return Icons.cut; // Default if no specific match
  }
}