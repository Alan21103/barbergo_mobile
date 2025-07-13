part of 'admin_pemesanan_bloc.dart';

@immutable
abstract class AdminPemesananEvent {
  const AdminPemesananEvent();
}

/// Event to load all bookings for the admin.
class GetAdminPemesananListEvent extends AdminPemesananEvent {
  const GetAdminPemesananListEvent();
}

// You can add more admin-specific booking events here (e.g., UpdateBookingStatusEvent)
class UpdatePemesananStatusEvent extends AdminPemesananEvent {
  final int id;
  final String status;

  const UpdatePemesananStatusEvent({
    required this.id,
    required this.status,
  });
}
