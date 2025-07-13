import 'package:barbergo_mobile/data/model/request/service/service_request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart'; // Import untuk listEquals
import 'package:barbergo_mobile/data/repository/service_repository.dart'; // Import ServiceRepository
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';



part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository; // Dependensi ke ServiceRepository

  ServiceBloc(this.serviceRepository) : super(ServiceInitial()) {
    // Handler untuk GetServicesEvent (memuat semua layanan)
    on<GetServicesEvent>((event, emit) async {
      emit(ServiceLoading()); // Emit Loading state
      final result = await serviceRepository.getServices(); // Panggil repository
      result.fold(
        (error) => emit(ServiceError(error)), // Jika gagal, emit Error state
        (services) => emit(ServiceLoaded(List.from(services))), // Jika berhasil, emit Loaded state dengan data (List.from untuk memaksa rebuild)
      );
    });

    // Handler untuk GetMyServicesEvent (memuat layanan milik barber yang login)
    on<GetMyServicesEvent>((event, emit) async {
      emit(ServiceLoading()); // Emit Loading state
      final result = await serviceRepository.getMyServices(); // Panggil repository
      result.fold(
        (error) => emit(ServiceError(error)), // Jika gagal, emit Error state
        (services) => emit(ServiceLoaded(List.from(services))), // Jika berhasil, emit Loaded state dengan data (List.from untuk memaksa rebuild)
      );
    });

    // Handler untuk CreateServiceEvent
    on<CreateServiceEvent>((event, emit) async {
      emit(ServiceCreating()); // Emit Creating state
      final requestModel = ServiceRequestModel(
        name: event.name,
        description: event.description,
        price: event.price,
      );
      final result = await serviceRepository.createService(requestModel); // Panggil repository
      result.fold(
        (error) => emit(ServiceActionFailure(error)), // Jika gagal, emit Failure state
        (data) {
          emit(ServiceActionSuccess('Layanan "${data.name}" berhasil dibuat!')); // Jika berhasil, emit Success state
          add(GetMyServicesEvent()); // Muat ulang layanan saya setelah berhasil
        },
      );
    });

    // Handler untuk UpdateServiceEvent
    on<UpdateServiceEvent>((event, emit) async {
      emit(ServiceUpdating()); // Emit Updating state
      final requestModel = ServiceRequestModel(
        name: event.name,
        description: event.description,
        price: event.price,
      );
      final result = await serviceRepository.updateService(event.id, requestModel); // Panggil repository
      result.fold(
        (error) => emit(ServiceActionFailure(error)), // Jika gagal, emit Failure state
        (data) {
          emit(ServiceActionSuccess('Layanan "${data.name}" berhasil diperbarui!')); // Jika berhasil, emit Success state
          add(GetMyServicesEvent()); // Muat ulang layanan saya setelah berhasil
        },
      );
    });

    // Handler untuk DeleteServiceEvent
    on<DeleteServiceEvent>((event, emit) async {
      emit(ServiceDeleting()); // Emit Deleting state
      final result = await serviceRepository.deleteService(event.id); // Panggil repository
      result.fold(
        (error) => emit(ServiceActionFailure(error)), // Jika gagal, emit Failure state
        (message) {
          emit(ServiceActionSuccess(message)); // Jika berhasil, emit Success state
          add(GetMyServicesEvent()); // Muat ulang layanan saya setelah berhasil
        },
      );
    });
  }
}
