// lib/presentation/auth/bloc/pemesanan/pemesanan_state.dart

part of 'pemesanan_bloc.dart'; // Penting: Pastikan ini benar

// Import Datum jika belum diimpor di file bloc.dart
// Jika Datum hanya digunakan di file state ini, Anda bisa import di sini
// import 'package:barbergo_mobile/data/model/request/pemesanan/get_all_pemesanan_response_model.dart'; 

@immutable // Menandakan bahwa objek ini tidak boleh diubah setelah dibuat
abstract class PemesananState {
  const PemesananState();
}

class PemesananInitial extends PemesananState {}

class PemesananLoadingState extends PemesananState {}

class PemesananLoadedState extends PemesananState {
  final List<Datum> pemesananDatumList;
  final String message; // <<<--- PROPERTI MESSAGE TETAP ADA

  const PemesananLoadedState(this.pemesananDatumList, this.message);
}

class PemesananErrorState extends PemesananState {
  final String error;

  const PemesananErrorState(this.error);
}

class PemesananAddErrorState extends PemesananState {
  final String error;

  const PemesananAddErrorState(this.error);
}

class PemesananSuccessState extends PemesananState {
  final String message;

  const PemesananSuccessState(this.message);
}

class PemesananCancelSuccessState extends PemesananState {
  final String message;

  const PemesananCancelSuccessState(this.message);
}

class PemesananCancelErrorState extends PemesananState {
  final String error;

  const PemesananCancelErrorState(this.error);
}

class PemesananDetailLoadingState extends PemesananState {}

class PemesananDetailLoadedState extends PemesananState {
  final Datum pemesananDetail;
  final PelangganProfileResponseModel profile;

    

  const PemesananDetailLoadedState(this.pemesananDetail, this.profile);
}

class PemesananDetailErrorState extends PemesananState {
  final String error;

  const PemesananDetailErrorState(this.error);
}

// Untuk respons setelah berhasil membuat pemesanan
class PemesananCreateSuccessState extends PemesananState {
  final PemesananResponseModel responseModel; // Bisa bawa data respons dari server
  const PemesananCreateSuccessState(this.responseModel);
}

// Untuk respons setelah berhasil memperbarui pemesanan
class PemesananUpdateSuccessState extends PemesananState {
  final PemesananResponseModel responseModel; // Bisa bawa data respons dari server
  const PemesananUpdateSuccessState(this.responseModel);
}

class ServicesLoadingState extends PemesananState {}
class ServicesLoadedState extends PemesananState {
  final List<GetAllServiceModel> services; // Menggunakan GetAllServiceModel
  const ServicesLoadedState(this.services);
}
class ServicesErrorState extends PemesananState {
  final String error;
  const ServicesErrorState(this.error);
}

class BarbersLoadingState extends PemesananState {}
class BarbersLoadedState extends PemesananState {
  final List<AdminDatum> barbers; // Menggunakan AdminDatum
  const BarbersLoadedState(this.barbers);
}
class BarbersErrorState extends PemesananState {
  final String error;
  const BarbersErrorState(this.error);
}