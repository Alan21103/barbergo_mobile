part of 'service_bloc.dart';

@immutable
sealed class ServiceState {}

/// State awal Bloc, sebelum operasi apapun dimulai.
final class ServiceInitial extends ServiceState {}

/// State saat data sedang dimuat dari repository.
final class ServiceLoading extends ServiceState {}

/// State ketika data layanan berhasil dimuat.
/// Berisi daftar [GetAllServiceModel] yang diterima.
final class ServiceLoaded extends ServiceState {
  final List<GetAllServiceModel> services;

  ServiceLoaded(this.services);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceLoaded &&
        listEquals(other.services, services); // Membandingkan list
  }

  @override
  int get hashCode => services.hashCode;
}

/// State ketika terjadi kesalahan saat memuat data layanan.
/// Berisi pesan kesalahan [message].
final class ServiceError extends ServiceState {
  final String message;

  ServiceError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceError &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// --- States baru untuk operasi CUD (Create, Update, Delete) ---

/// State saat operasi pembuatan layanan sedang berlangsung.
final class ServiceCreating extends ServiceState {}

/// State saat operasi pembaruan layanan sedang berlangsung.
final class ServiceUpdating extends ServiceState {}

/// State saat operasi penghapusan layanan sedang berlangsung.
final class ServiceDeleting extends ServiceState {}

/// State ketika operasi CUD berhasil.
/// Berisi pesan sukses [message].
final class ServiceActionSuccess extends ServiceState {
  final String message;

  ServiceActionSuccess(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceActionSuccess &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// State ketika operasi CUD gagal.
/// Berisi pesan kesalahan [error].
final class ServiceActionFailure extends ServiceState {
  final String error;

  ServiceActionFailure(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceActionFailure &&
        other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
