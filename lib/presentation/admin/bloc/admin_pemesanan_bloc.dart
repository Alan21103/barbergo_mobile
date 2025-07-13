import 'dart:developer'; // Import for log

import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/repository/admin_repository.dart'; // Import AdminRepository
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'admin_pemesanan_event.dart';
part 'admin_pemesanan_state.dart';

class AdminPemesananBloc extends Bloc<AdminPemesananEvent, AdminPemesananState> {
  final AdminRepository adminRepository;

  AdminPemesananBloc({
    required this.adminRepository,
  }) : super(AdminPemesananInitial()) {
    on<GetAdminPemesananListEvent>(_getAdminPemesananList);
    // Menambahkan handler untuk event UpdatePemesananStatusEvent
    on<UpdatePemesananStatusEvent>(_updatePemesananStatus);
  }

  /// Handler for loading all admin bookings using AdminRepository.
  Future<void> _getAdminPemesananList(
    GetAdminPemesananListEvent event,
    Emitter<AdminPemesananState> emit,
  ) async {
    emit(AdminPemesananLoading());
    final result = await adminRepository.getAllPemesanan(); // Call the admin repository method
    result.fold(
      (error) {
        log('Error loading admin bookings: $error');
        emit(AdminPemesananError(error));
      },
      (data) {
        log('Successfully loaded admin bookings: ${data.length} items');
        // Ensure a new list instance to force rebuild
        emit(AdminPemesananLoaded(List.from(data)));
      },
    );
  }

  /// Handler for updating booking status.
  Future<void> _updatePemesananStatus(
    UpdatePemesananStatusEvent event,
    Emitter<AdminPemesananState> emit,
  ) async {
    emit(AdminPemesananUpdating()); // Emit state indicating update is in progress
    final result = await adminRepository.updatePemesananStatus(event.id, event.status);
    result.fold(
      (error) {
        log('Failed to update booking status for ID ${event.id}: $error');
        emit(AdminPemesananActionFailure(error)); // Emit failure state
      },
      (message) {
        log('Booking status updated successfully for ID ${event.id}: $message');
        emit(AdminPemesananActionSuccess(message)); // Emit success state
        // Setelah sukses update, muat ulang daftar pemesanan untuk menampilkan perubahan terbaru
        add(const GetAdminPemesananListEvent());
      },
    );
  }
}
