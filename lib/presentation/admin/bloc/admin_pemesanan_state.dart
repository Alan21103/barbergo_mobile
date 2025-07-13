part of 'admin_pemesanan_bloc.dart';

@immutable
abstract class AdminPemesananState {
  const AdminPemesananState();
}

class AdminPemesananInitial extends AdminPemesananState {}

/// State indicating that admin bookings are being loaded.
class AdminPemesananLoading extends AdminPemesananState {}

/// State indicating that admin bookings have been successfully loaded.
class AdminPemesananLoaded extends AdminPemesananState {
  final List<PemesananData> pemesananList;

  const AdminPemesananLoaded(this.pemesananList);

  List<Object> get props => [pemesananList];
}

/// State indicating an error occurred while loading admin bookings.
class AdminPemesananError extends AdminPemesananState {
  final String message;

  const AdminPemesananError(this.message);

  List<Object> get props => [message];
}

// States for actions (e.g., updating booking status)
class AdminPemesananUpdating extends AdminPemesananState {} // New state for updating

class AdminPemesananActionSuccess extends AdminPemesananState {
  final String message;
  const AdminPemesananActionSuccess(this.message);
}

class AdminPemesananActionFailure extends AdminPemesananState {
  final String error;
  const AdminPemesananActionFailure(this.error);
}
