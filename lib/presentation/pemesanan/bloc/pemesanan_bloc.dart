import 'dart:developer';

import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/request/pemesanan/pemesanan_request_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';
import 'package:barbergo_mobile/data/repository/pemesanan_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pemesanan_event.dart';
part 'pemesanan_state.dart';

class PemesananBloc extends Bloc<PemesananEvent, PemesananState> {
  final PemesananRepository pemesananRepository;

  PemesananBloc({required this.pemesananRepository})
    : super(PemesananInitial()) {
    on<GetPemesananListEvent>(_getPemesananList);
    on<CreatePemesananEvent>(_createPemesanan);
    on<UpdatePemesananEvent>(_updatePemesanan);
    on<DeletePemesananEvent>(_deletePemesanan);
    on<CancelPemesananEvent>(_cancelPemesanan);
    on<GetPemesananDetailEvent>(_getPemesananDetail);
    on<LoadServicesEvent>(_loadServices);
    on<LoadBarbersEvent>(_loadBarbers);
  }

  // Get list of Pemesanan
  Future<void> _getPemesananList(
    GetPemesananListEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananLoadingState());
    // Pastikan pemesananRepository.getPemesananList() mengembalikan GetAllPemesananResponseModel
    final result = await pemesananRepository.getPemesananList();

    result.fold(
      (error) {
        emit(PemesananErrorState(error));
      },
      (fullResponseModel) {
        // <<<--- INI YANG BERUBAH: Sekarang menerima model respons utuh
        emit(
          PemesananLoadedState(
            fullResponseModel.data ?? [], // Ambil list data
            fullResponseModel.message ??
                'Data berhasil dimuat.', // Ambil pesan dari respons
          ),
        );
      },
    );
  }

  // Create a new Pemesanan
  Future<void> _createPemesanan(
    CreatePemesananEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananLoadingState());
    final result = await pemesananRepository.createPemesanan(
      event.requestModel,
    );
    result.fold(
      (error) => emit(PemesananAddErrorState(error)),
      (response) => emit(
        PemesananCreateSuccessState(response),
      ), // Menggunakan state spesifik
    );
  }

  // Update an existing Pemesanan
  Future<void> _updatePemesanan(
    UpdatePemesananEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananLoadingState());
    final result = await pemesananRepository.updatePemesanan(
      event.id,
      event.requestModel,
    );
    result.fold(
      (error) => emit(PemesananErrorState(error)),
      (response) => emit(
        PemesananUpdateSuccessState(response),
      ), // Menggunakan state spesifik
    );
  }

  // Delete an existing Pemesanan
  Future<void> _deletePemesanan(
    DeletePemesananEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananLoadingState());
    final result = await pemesananRepository.deletePemesanan(event.id);
    result.fold(
      (error) => emit(PemesananErrorState(error)),
      (message) => emit(PemesananSuccessState('Pemesanan berhasil dihapus!')),
    );
  }

  // Handle Cancel Pemesanan
  Future<void> _cancelPemesanan(
    CancelPemesananEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananLoadingState()); // Show loading while canceling

    // Call repository method to cancel the pemesanan by ID
    final result = await pemesananRepository.cancelPemesanan(event.id);

    result.fold(
      (error) {
        emit(PemesananCancelErrorState('Gagal membatalkan pesanan: $error'));
      },
      (message) {
        emit(PemesananCancelSuccessState('Pesanan berhasil dibatalkan.'));
      },
    );
  }

 Future<void> _getPemesananDetail(
    GetPemesananDetailEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(PemesananDetailLoadingState());
    try {
      // Fetch detail pemesanan
      final pemesananResult = await pemesananRepository.getPemesananById(event.id);

      // Fetch profil pelanggan
      // Asumsi ada endpoint untuk mendapatkan profil pelanggan yang sedang login
      // Atau, jika profil pelanggan terkait dengan pemesanan, Anda mungkin perlu
      // mendapatkan pelanggan_id dari pemesananDetail terlebih dahulu.
      // Untuk saat ini, kita asumsikan ada method di repository untuk mendapatkan profil user yang login.
      final profileResult = await pemesananRepository.getUserProfile(); // NEW: Panggil method untuk mendapatkan profil

      pemesananResult.fold(
        (pemesananError) {
          emit(PemesananDetailErrorState('Gagal memuat detail pesanan: $pemesananError'));
        },
        (pemesananDetail) {
          profileResult.fold(
            (profileError) {
              // Jika detail pemesanan berhasil dimuat tapi profil gagal,
              // Anda bisa memilih untuk tetap menampilkan detail pemesanan
              // dengan pesan error untuk profil, atau menganggapnya sebagai error keseluruhan.
              // Untuk saat ini, kita anggap error keseluruhan.
              emit(PemesananDetailErrorState('Gagal memuat profil pelanggan: $profileError'));
            },
            (profile) {
              emit(PemesananDetailLoadedState(pemesananDetail, profile));
              log('PemesananBloc: Successfully loaded pemesanan detail and profile.');
            },
          );
        },
      );
    } catch (e) {
      emit(PemesananDetailErrorState('Terjadi kesalahan tak terduga: ${e.toString()}'));
      log('PemesananBloc: Unexpected error in _getPemesananDetail: $e');
    }
  }

  Future<void> _loadServices(
    LoadServicesEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(ServicesLoadingState());
    final result = await pemesananRepository.getServices();
    result.fold(
      (error) => emit(ServicesErrorState(error)),
      (services) =>
          emit(ServicesLoadedState(services)), // Menggunakan GetAllServiceModel
    );
  }

  Future<void> _loadBarbers(
    LoadBarbersEvent event,
    Emitter<PemesananState> emit,
  ) async {
    emit(BarbersLoadingState());
    final result = await pemesananRepository.getBarbers();
    result.fold(
      (error) => emit(BarbersErrorState(error)),
      (barbers) => emit(BarbersLoadedState(barbers)), // Menggunakan AdminDatum
    );
  }
}
