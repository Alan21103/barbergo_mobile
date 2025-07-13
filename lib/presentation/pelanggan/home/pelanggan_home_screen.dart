// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbergo_mobile/core/components/custom_navbar.dart';
import 'package:barbergo_mobile/data/model/response/jadwal/get_all_jadwal_response_model.dart';
import 'package:barbergo_mobile/data/model/response/portofolios/get_all_portofolios_response_model.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_bloc.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_event.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_state.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/header_area.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/jadwal_section.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/main_content.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/portofolio_section.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/review_section.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/widgets/service_section.dart';
import 'package:barbergo_mobile/presentation/pelanggan/jadwal/bloc/jadwal_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_bloc.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_event.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

// Import Bloc, Events, States yang relevan
import 'package:barbergo_mobile/presentation/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/response/review/get_all_review_response_model.dart';

import '../../../data/model/response/pelanggan/pelanggan_profile_response_model.dart';


class PelangganHomeScreen extends StatefulWidget {

  const PelangganHomeScreen({
    super.key,
  });
  

  @override
  State<PelangganHomeScreen> createState() => _PelangganHomeScreenState();
}

class _PelangganHomeScreenState extends State<PelangganHomeScreen> {
  // Data untuk ditampilkan
  List<Datum> _jadwalList = []; // Untuk jadwal/pemesanan (bookings)
  List<GetAllServiceModel> _serviceList = []; // Untuk layanan
  List<AdminDatum> _barbersList = []; // Untuk daftar barber lengkap (AdminDatum)
  List<PortofolioDatum> _portofolioImagesList = []; // Untuk daftar gambar portofolio
  List<JadwalDatum> _barberScheduleList = []; // Untuk jadwal tetap barber
  List<ReviewDatum> _reviewList = []; // Untuk daftar review
  

  bool _isLoadingPemesanan = false;
  bool _isLoadingServices = false;
  bool _isLoadingBarbers = false;
  bool _isLoadingBarberSchedules = false;
  bool _isLoadingReviews = false;
  bool _isLoadingPortofolios = false; // Loading state untuk portofolio gambar

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    log('PelangganHomeScreen: Initializing state...');
    context.read<PemesananBloc>().add(GetPemesananListEvent());
    log('PelangganHomeScreen: Dispatched GetPemesananListEvent');
    context.read<PemesananBloc>().add(LoadServicesEvent());
    log('PelangganHomeScreen: Dispatched LoadServicesEvent');
    context.read<PemesananBloc>().add(LoadBarbersEvent()); // Ini akan memuat AdminDatum
    log('PelangganHomeScreen: Dispatched LoadBarbersEvent');
    
    // Dispatch event untuk PortofoliosBloc yang baru
    context.read<PortofoliosBloc>().add(GetPortofoliosEvent()); // Menggunakan GetPortofoliosEvent dari PortofoliosBloc
    log('PelangganHomeScreen: Dispatched GetPortofoliosEvent to PortofoliosBloc'); 
    
    context.read<JadwalBloc>().add(const LoadAllJadwalEvent()); // Menggunakan const karena event tidak memiliki properti yang berubah
    log('PelangganHomeScreen: Dispatched LoadAllJadwalEvent to JadwalBloc');
    context.read<ReviewBloc>().add(LoadReviewsEvent());
    log('PelangganHomeScreen: Dispatched LoadReviewsEvent to ReviewBloc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<PemesananBloc, PemesananState>(
            listener: (context, state) {
              if (state is PemesananLoadingState) {
                setState(() => _isLoadingPemesanan = true);
                log('PemesananBloc: PemesananLoadingState');
              } else if (state is PemesananLoadedState) {
                setState(() {
                  _isLoadingPemesanan = false;
                  _jadwalList = state.pemesananDatumList;
                });
                log('PemesananBloc: PemesananLoadedState. Count: ${_jadwalList.length}');
              } else if (state is PemesananErrorState) {
                setState(() => _isLoadingPemesanan = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat jadwal pemesanan: ${state.error}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('PemesananBloc: PemesananErrorState: ${state.error}');
              } else if (state is ServicesLoadingState) {
                setState(() => _isLoadingServices = true);
                log('PemesananBloc: ServicesLoadingState');
              } else if (state is ServicesLoadedState) {
                setState(() {
                  _isLoadingServices = false;
                  _serviceList = state.services;
                });
                log('PemesananBloc: ServicesLoadedState. Count: ${_serviceList.length}');
              } else if (state is ServicesErrorState) {
                setState(() => _isLoadingServices = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat layanan: ${state.error}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('PemesananBloc: ServicesErrorState: ${state.error}');
              } else if (state is BarbersLoadingState) {
                setState(() => _isLoadingBarbers = true);
                log('PemesananBloc: BarbersLoadingState');
              } else if (state is BarbersLoadedState) {
                setState(() {
                  _isLoadingBarbers = false;
                  _barbersList = state.barbers; // MENGGUNAKAN NAMA VARIABEL BARU
                });
                log('PemesananBloc: BarbersLoadedState. Count: ${_barbersList.length}');
              } else if (state is BarbersErrorState) {
                setState(() => _isLoadingBarbers = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat tukang cukur: ${state.error}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('PemesananBloc: BarbersErrorState: ${state.error}');
              }
            },
          ),
          // Listener untuk PortofoliosBloc yang baru
          BlocListener<PortofoliosBloc, PortofoliosState>( // Menggunakan PortofoliosBloc
            listener: (context, state) {
              if (state is PortofoliosLoading) { // Menggunakan PortofoliosLoading
                setState(() => _isLoadingPortofolios = true); // Update loading state
                log('PortofoliosBloc: PortofoliosLoading');
              } else if (state is PortofoliosLoaded) { // Menggunakan PortofoliosLoaded
                setState(() {
                  _isLoadingPortofolios = false; // Update loading state
                  _portofolioImagesList = state.portfolios;
                });
                log('PortofoliosBloc: PortofoliosLoaded. Count: ${_portofolioImagesList.length}');
              } else if (state is PortofoliosError) { // Menggunakan PortofoliosError
                setState(() => _isLoadingPortofolios = false); // Update loading state
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat portofolio: ${state.message}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('PortofoliosBloc: PortofoliosError: ${state.message}');
              }
            },
          ),
          BlocListener<JadwalBloc, JadwalState>(
            listener: (context, state) {
              if (state is JadwalLoadingState) {
                setState(() => _isLoadingBarberSchedules = true);
                log('JadwalBloc: JadwalLoadingState');
              } else if (state is JadwalLoadedState) {
                setState(() {
                  _isLoadingBarberSchedules = false;
                  _barberScheduleList = state.schedules;
                });
                log('JadwalBloc: Schedules loaded. Count: ${_barberScheduleList.length}');
              } else if (state is JadwalErrorState) {
                setState(() => _isLoadingBarberSchedules = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat jadwal barber: ${state.error}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('JadwalBloc: Error loading schedules: ${state.error}');
              }
            },
          ),
          BlocListener<ReviewBloc, ReviewState>(
            listener: (context, state) {
              if (state is ReviewsLoadingState) {
                setState(() => _isLoadingReviews = true);
                log('ReviewBloc: ReviewsLoadingState');
              } else if (state is ReviewsLoadedState) {
                setState(() {
                  _isLoadingReviews = false;
                  _reviewList = state.reviews;
                });
                log('ReviewBloc: ReviewsLoadedState. Count: ${_reviewList.length}');
              } else if (state is ReviewsErrorState) {
                setState(() => _isLoadingReviews = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat review: ${state.error}', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
                log('ReviewBloc: ReviewsErrorState: ${state.error}');
              }
            },
          ),
        ],
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Wallpaper.jpg',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            Column(
              children: [
                const Expanded(
                  flex: 1,
                  child:    
                  HomeHeaderSection(),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SearchBarSection(),
                          const SizedBox(height: 20),

                          ServicesSection(
                            isLoading: _isLoadingServices,
                            serviceList: _serviceList,
                          ),
                          const SizedBox(height: 20),

                          JadwalSection(
                            isLoading: _isLoadingPemesanan,
                            jadwalList: _jadwalList,
                          ),
                          const SizedBox(height: 20),

                          // Menggunakan PortfolioSection
                          PortfolioSection(
                            isLoadingPortofolios: _isLoadingPortofolios, // Meneruskan loading state baru
                            portfolios: _portofolioImagesList, // Meneruskan PortofolioDatum yang sebenarnya
                            // Parameter lain yang mungkin tidak relevan untuk PortofolioSection bisa dihapus atau disesuaikan
                            barberScheduleList: _barberScheduleList, // Tetap diperlukan
                            barbersList: _barbersList, // Tetap diperlukan
                          ),
                          const SizedBox(height: 20),

                          ReviewsSection(
                            isLoading: _isLoadingReviews,
                            reviewList: _reviewList,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
