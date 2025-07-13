part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

/// Event untuk memuat semua layanan dari repository.
class GetServicesEvent extends ServiceEvent {}

/// Event untuk memuat layanan milik barber yang sedang login.
class GetMyServicesEvent extends ServiceEvent {}

/// Event untuk membuat layanan baru.
class CreateServiceEvent extends ServiceEvent {
  final String name;
  final String description;
  final String price; // Menggunakan String sesuai ServiceRequestModel

  CreateServiceEvent({
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateServiceEvent &&
        other.name == name &&
        other.description == description &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ price.hashCode;
}

/// Event untuk memperbarui layanan yang sudah ada.
class UpdateServiceEvent extends ServiceEvent {
  final int id;
  final String name;
  final String description;
  final String price; // Menggunakan String sesuai ServiceRequestModel

  UpdateServiceEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateServiceEvent &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ price.hashCode;
}

/// Event untuk menghapus layanan.
class DeleteServiceEvent extends ServiceEvent {
  final int id;

  DeleteServiceEvent({required this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteServiceEvent &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
