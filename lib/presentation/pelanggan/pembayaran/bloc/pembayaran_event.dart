part of 'pembayaran_bloc.dart';

@immutable
abstract class PembayaranEvent {
  const PembayaranEvent();
}

/// Event untuk membuat pembayaran baru.
class CreatePembayaranEvent extends PembayaranEvent {
  final PembayaranRequestModel requestModel;

  const CreatePembayaranEvent(this.requestModel);
}

/// Event untuk mengambil semua daftar pembayaran.
class GetAllPembayaranEvent extends PembayaranEvent {
  const GetAllPembayaranEvent();
}
