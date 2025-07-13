// lib/presentation/pembayaran/bloc/pembayaran_bloc.dart

import 'package:barbergo_mobile/data/model/response/pembayaran/get_all_pembayaran_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pembayaran/pembayaran_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // Import material.dart untuk @immutable
import 'package:barbergo_mobile/data/repository/pembayaran_repository.dart'; // Import repository
import 'package:barbergo_mobile/data/model/request/pembayaran/pembayaran_request_model.dart'; // Import request model

part 'pembayaran_event.dart';
part 'pembayaran_state.dart';

class PembayaranBloc extends Bloc<PembayaranEvent, PembayaranState> {
  final PembayaranRepository pembayaranRepository;

  PembayaranBloc({required this.pembayaranRepository}) : super(PembayaranInitial()) {
    // Handler untuk event CreatePembayaranEvent
    on<CreatePembayaranEvent>((event, emit) async {
      emit(PembayaranLoading());
      final result = await pembayaranRepository.createPembayaran(event.requestModel);
      result.fold(
        (error) => emit(PembayaranError(error)),
        (responseModel) => emit(PembayaranSuccess(responseModel.message ?? 'Pembayaran berhasil.')),
      );
    });

    // Handler untuk event GetAllPembayaranEvent
    on<GetAllPembayaranEvent>((event, emit) async {
      emit(PembayaranLoading());
      final result = await pembayaranRepository.getAllPembayaran();
      result.fold(
        (error) => emit(PembayaranError(error)),
        (responseModel) => emit(PembayaranLoaded(pembayaranList: responseModel.data ?? [])),
      );
    });
  }
}
