import 'package:barbergo_mobile/data/model/request/portofolio/portofolio_request_model.dart';
import 'package:barbergo_mobile/data/repository/portofolio_repository.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_event.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import untuk listEquals

class PortofoliosBloc extends Bloc<PortofoliosEvent, PortofoliosState> {
  final PortofolioRepository portofolioRepository; // Dependensi ke PortofolioRepository

  PortofoliosBloc(this.portofolioRepository) : super(PortofoliosInitial()) {
    // Handler untuk GetPortofoliosEvent (memuat semua portofolio)
    on<GetPortofoliosEvent>((event, emit) async {
      emit(PortofoliosLoading()); // Emit Loading state
      final result = await portofolioRepository.getAllPortofolios(); // Panggil repository
      result.fold(
        (error) => emit(PortofoliosError(message: error)), // Jika gagal, emit Error state
        (portfolios) => emit(PortofoliosLoaded(portfolios: List.from(portfolios))), // Jika berhasil, emit Loaded state dengan data
      );
    });

    // Handler untuk GetMyPortofoliosEvent (memuat portofolio milik barber yang login)
    on<GetMyPortofoliosEvent>((event, emit) async {
      emit(PortofoliosLoading()); // Emit Loading state
      final result = await portofolioRepository.getMyPortofolios(); // Panggil repository
      result.fold(
        (error) => emit(PortofoliosError(message: error)), // Jika gagal, emit Error state
        (portfolios) => emit(PortofoliosLoaded(portfolios: List.from(portfolios))), // Jika berhasil, emit Loaded state dengan data
      );
    });

    // Handler untuk CreatePortofoliosEvent
    on<CreatePortofoliosEvent>((event, emit) async {
      emit(PortofoliosCreating()); // Emit Creating state
      final requestModel = PortofolioRequestModel(
        image: event.image,
        description: event.description,
      );
      final result = await portofolioRepository.createPortofolio(requestModel); // Panggil repository
      result.fold(
        (error) => emit(PortofoliosActionFailure(error: error)), // Jika gagal, emit Failure state
        (data) {
          emit(PortofoliosActionSuccess(message: 'Portofolio berhasil dibuat!')); // Jika berhasil, emit Success state
          add(GetMyPortofoliosEvent()); // Muat ulang portofolio saya setelah berhasil
        },
      );
    });

    // Handler untuk UpdatePortofoliosEvent
    on<UpdatePortofoliosEvent>((event, emit) async {
      emit(PortofoliosUpdating()); // Emit Updating state
      final requestModel = PortofolioRequestModel(
        image: event.image,
        description: event.description,
      );
      final result = await portofolioRepository.updatePortofolio(event.id, requestModel); // Panggil repository
      result.fold(
        (error) => emit(PortofoliosActionFailure(error: error)), // Jika gagal, emit Failure state
        (data) {
          emit(PortofoliosActionSuccess(message: 'Portofolio berhasil diperbarui!')); // Jika berhasil, emit Success state
          add(GetMyPortofoliosEvent()); // Muat ulang portofolio saya setelah berhasil
        },
      );
    });

    // Handler untuk DeletePortofoliosEvent
    on<DeletePortofoliosEvent>((event, emit) async {
      emit(PortofoliosDeleting()); // Emit Deleting state
      final result = await portofolioRepository.deletePortofolio(event.id); // Panggil repository
      result.fold(
        (error) => emit(PortofoliosActionFailure(error: error)), // Jika gagal, emit Failure state
        (message) {
          emit(PortofoliosActionSuccess(message: message)); // Jika berhasil, emit Success state
          add(GetMyPortofoliosEvent()); // Muat ulang portofolio saya setelah berhasil
        },
      );
    });
  }
}
