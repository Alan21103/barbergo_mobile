import 'dart:developer'; // Import untuk log

import 'package:barbergo_mobile/data/model/response/jadwal/get_all_jadwal_response_model.dart';
import 'package:barbergo_mobile/data/repository/jadwal_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


part 'jadwal_event.dart';
part 'jadwal_state.dart';

class JadwalBloc extends Bloc<JadwalEvent, JadwalState> {
  final JadwalRepository jadwalRepository;

  JadwalBloc({required this.jadwalRepository}) : super(JadwalInitial()) {
    on<LoadAllJadwalEvent>(_loadAllJadwal);
    on<LoadMyJadwalEvent>(_loadMyJadwal);
    on<CreateMyJadwalEvent>(_createMyJadwal);
    on<UpdateMyJadwalEvent>(_updateMyJadwal);
    on<DeleteMyJadwalEvent>(_deleteMyJadwal);
  }

  // Handler untuk memuat semua jadwal (misalnya, untuk tampilan admin)
  Future<void> _loadAllJadwal(
    LoadAllJadwalEvent event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalLoadingState());
    final result = await jadwalRepository.getBarberSchedules(); // Menggunakan getAllJadwal
    result.fold(
      (error) {
        log('Error loading all schedules: $error');
        emit(JadwalErrorState(error));
      },
      (schedules) {
        log('Successfully loaded all schedules: ${schedules.length} items');
        // Memastikan instance list baru untuk memaksa rebuild
        emit(JadwalLoadedState(List.from(schedules)));
      },
    );
  }

  // Handler untuk memuat jadwal milik barber yang sedang login
  Future<void> _loadMyJadwal(
    LoadMyJadwalEvent event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalLoadingState()); // Bisa menggunakan state yang lebih spesifik jika diperlukan
    final result = await jadwalRepository.getMyJadwal();
    result.fold(
      (error) {
        log('Error loading my schedules: $error');
        emit(JadwalErrorState(error));
      },
      (schedules) {
        log('Successfully loaded my schedules: ${schedules.length} items');
        // Memastikan instance list baru untuk memaksa rebuild
        emit(JadwalLoadedState(List.from(schedules)));
      },
    );
  }

  // Handler untuk membuat jadwal baru untuk barber yang sedang login
  Future<void> _createMyJadwal(
    CreateMyJadwalEvent event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalCreatingState());
    final data = {
      'hari': event.hari,
      'tersedia_dari': event.tersediaDari,
      'tersedia_hingga': event.tersediaHingga,
    };
    final result = await jadwalRepository.createMyJadwal(data);
    result.fold(
      (error) {
        log('Failed to create schedule: $error');
        emit(JadwalActionFailure(error));
      },
      (newJadwal) {
        log('Schedule created successfully: ${newJadwal.id}');
        emit(JadwalActionSuccess('Jadwal berhasil dibuat!'));
        // Setelah sukses, muat ulang daftar jadwal untuk admin
        add(const LoadAllJadwalEvent()); // Menggunakan LoadAllJadwalEvent
      },
    );
  }

  // Handler untuk memperbarui jadwal yang sudah ada milik barber yang sedang login
  Future<void> _updateMyJadwal(
    UpdateMyJadwalEvent event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalUpdatingState());
    final data = {
      'hari': event.hari,
      'tersedia_dari': event.tersediaDari,
      'tersedia_hingga': event.tersediaHingga,
    };
    final result = await jadwalRepository.updateMyJadwal(event.id, data);
    result.fold(
      (error) {
        log('Failed to update schedule ${event.id}: $error');
        emit(JadwalActionFailure(error));
      },
      (updatedJadwal) {
        log('Schedule updated successfully: ${updatedJadwal.id}');
        emit(JadwalActionSuccess('Jadwal berhasil diperbarui!'));
        // Setelah sukses, muat ulang daftar jadwal untuk admin
        add(const LoadAllJadwalEvent()); // Menggunakan LoadAllJadwalEvent
      },
    );
  }

  // Handler untuk menghapus jadwal milik barber yang sedang login
  Future<void> _deleteMyJadwal(
    DeleteMyJadwalEvent event,
    Emitter<JadwalState> emit,
  ) async {
    emit(JadwalDeletingState());
    final result = await jadwalRepository.deleteMyJadwal(event.id);
    result.fold(
      (error) {
        log('Failed to delete schedule ${event.id}: $error');
        emit(JadwalActionFailure(error));
      },
      (message) {
        log('Schedule deleted successfully: $message');
        emit(JadwalActionSuccess(message));
        // Setelah sukses, muat ulang daftar jadwal untuk admin
        add(const LoadAllJadwalEvent()); // Menggunakan LoadAllJadwalEvent
      },
    );
  }
}
