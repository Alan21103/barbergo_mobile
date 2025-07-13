// lib/presentation/auth/bloc/pemesanan/pemesanan_event.dart

part of 'pemesanan_bloc.dart'; // Penting: Pastikan ini benar

@immutable // Menandakan bahwa objek ini tidak boleh diubah setelah dibuat
abstract class PemesananEvent {
  const PemesananEvent(); // Pastikan konstruktor konstan jika memungkinkan
}

class GetPemesananListEvent extends PemesananEvent {
  const GetPemesananListEvent();
}

class CreatePemesananEvent extends PemesananEvent {
  final PemesananRequestModel requestModel;

  const CreatePemesananEvent(this.requestModel);
}

class UpdatePemesananEvent extends PemesananEvent {
  final int id;
  final PemesananRequestModel requestModel;

  const UpdatePemesananEvent(this.id, this.requestModel);
}

class DeletePemesananEvent extends PemesananEvent {
  final int id;

  const DeletePemesananEvent(this.id);
}

class CancelPemesananEvent extends PemesananEvent {
  final String id;

  const CancelPemesananEvent(this.id);
}

class GetPemesananDetailEvent extends PemesananEvent {
  final String id;

  const GetPemesananDetailEvent(this.id);
}

// --- Event baru untuk memuat data dropdown secara terpisah ---
class LoadServicesEvent extends PemesananEvent {
  const LoadServicesEvent();
}

class LoadBarbersEvent extends PemesananEvent {
  const LoadBarbersEvent();
}
