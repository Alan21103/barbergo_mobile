import 'dart:developer'; // Untuk log
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart'; // Untuk listEquals
import 'package:meta/meta.dart';

import 'package:barbergo_mobile/data/model/response/admin/get_all_pembayaran_response_model.dart'; // Import model pembayaran
import 'package:barbergo_mobile/data/repository/admin_repository.dart'; // Import AdminRepository

part 'admin_pembayaran_event.dart';
part 'admin_pembayaran_state.dart';

class AdminPembayaranBloc
    extends Bloc<AdminPembayaranEvent, AdminPembayaranState> {
  final AdminRepository adminRepository;

  AdminPembayaranBloc({required this.adminRepository})
    : super(AdminPembayaranInitial()) {
    on<GetAdminPembayaranListEvent>(_onGetAdminPembayaranListEvent);
    on<UpdatePembayaranStatusEvent>(
      _onUpdatePembayaranStatusEvent,
    ); // Tambahkan handler untuk event baru
  }

  Future<void> _onGetAdminPembayaranListEvent(
    GetAdminPembayaranListEvent event,
    Emitter<AdminPembayaranState> emit,
  ) async {
    emit(AdminPembayaranLoading());
    final result =
        await adminRepository
            .getAllPembayaran(); // Memanggil method dari AdminRepository

    result.fold(
      (error) {
        log('Error loading admin pembayaran: $error');
        emit(AdminPembayaranError(message: error));
      },
      (pembayaranList) {
        log(
          'Successfully loaded admin pembayaran: ${pembayaranList.length} items',
        );
        // Menggunakan List.from untuk membuat instance list baru dan memaksa rebuild
        emit(AdminPembayaranLoaded(pembayaranList: List.from(pembayaranList)));
      },
    );
  }

  Future<void> _onUpdatePembayaranStatusEvent(
    UpdatePembayaranStatusEvent event,
    Emitter<AdminPembayaranState> emit,
  ) async {
    emit(AdminPembayaranUpdating()); // Emit state sedang memperbarui
    final result = await adminRepository.updatePembayaranStatus(event.id, event.status);
    result.fold(
      (error) {
        log('Failed to update pembayaran status: $error');
        emit(AdminPembayaranActionFailure(error: error)); // Emit state gagal
      },
      (message) {
        log('Pembayaran status updated successfully: $message');
        emit(AdminPembayaranActionSuccess(message: message)); // Emit state sukses
        add(const GetAdminPembayaranListEvent()); // Muat ulang daftar setelah sukses
      },
    );
  }
}
