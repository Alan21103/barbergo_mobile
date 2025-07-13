// lib/presentation/pembayaran/bloc/pembayaran_state.dart

part of 'pembayaran_bloc.dart';

@immutable
abstract class PembayaranState {
  const PembayaranState();
}

/// State awal untuk Pembayaran Bloc.
class PembayaranInitial extends PembayaranState {}

/// State saat operasi pembayaran sedang berlangsung (loading).
class PembayaranLoading extends PembayaranState {}

/// State saat pembayaran berhasil dibuat.
class PembayaranSuccess extends PembayaranState {
  final String message;

  const PembayaranSuccess(this.message);
}

/// State saat terjadi kesalahan dalam operasi pembayaran.
class PembayaranError extends PembayaranState {
  final String error;

  const PembayaranError(this.error);
}

/// State saat daftar pembayaran berhasil dimuat.
class PembayaranLoaded extends PembayaranState {
  final List<PembayaranDatum> pembayaranList;

  const PembayaranLoaded({required this.pembayaranList});
}
