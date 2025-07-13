part of 'admin_pembayaran_bloc.dart';

@immutable
abstract class AdminPembayaranState {
  const AdminPembayaranState();
}

/// State awal Bloc Pembayaran.
class AdminPembayaranInitial extends AdminPembayaranState {}

/// State saat data pembayaran sedang dimuat.
class AdminPembayaranLoading extends AdminPembayaranState {}

/// State ketika data pembayaran berhasil dimuat.
/// Berisi daftar [PembayaranData] yang diterima.
class AdminPembayaranLoaded extends AdminPembayaranState {
  final List<PembayaranData> pembayaranList;

  const AdminPembayaranLoaded({required this.pembayaranList});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminPembayaranLoaded &&
        listEquals(other.pembayaranList, pembayaranList);
  }

  @override
  int get hashCode => pembayaranList.hashCode;
}

/// State ketika terjadi kesalahan saat memuat data pembayaran.
/// Berisi pesan kesalahan [message].
class AdminPembayaranError extends AdminPembayaranState {
  final String message;

  const AdminPembayaranError({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminPembayaranError &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// Anda bisa menambahkan state lain di sini untuk operasi CUD (Create, Update, Delete)
// Contoh:
// class AdminPembayaranUpdating extends AdminPembayaranState {}
// class AdminPembayaranActionSuccess extends AdminPembayaranState {
//   final String message;
//   const AdminPembayaranActionSuccess({required this.message});
// }
// class AdminPembayaranActionFailure extends AdminPembayaranState {
//   final String error;
//   const AdminPembayaranActionFailure({required this.error});
// }
class AdminPembayaranUpdating extends AdminPembayaranState {}

/// State ketika operasi aksi (misalnya update) berhasil.
/// Berisi pesan sukses [message].
class AdminPembayaranActionSuccess extends AdminPembayaranState {
  final String message;
  const AdminPembayaranActionSuccess({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminPembayaranActionSuccess &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// State ketika operasi aksi (misalnya update) gagal.
/// Berisi pesan kesalahan [error].
class AdminPembayaranActionFailure extends AdminPembayaranState {
  final String error;
  const AdminPembayaranActionFailure({required this.error});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminPembayaranActionFailure &&
        other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}