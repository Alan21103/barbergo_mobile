part of 'admin_pembayaran_bloc.dart';

@immutable
abstract class AdminPembayaranEvent {
  const AdminPembayaranEvent();
}

/// Event untuk memuat daftar semua pembayaran untuk admin.
class GetAdminPembayaranListEvent extends AdminPembayaranEvent {
  const GetAdminPembayaranListEvent();
}

class UpdatePembayaranStatusEvent extends AdminPembayaranEvent {
  final int id;
  final String status;
  const UpdatePembayaranStatusEvent({required this.id, required this.status});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdatePembayaranStatusEvent &&
        other.id == id &&
        other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;
}