// lib/data/repository/admin_repository.dart
import 'dart:convert'; // Import untuk json.decode
import 'dart:developer';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_pembayaran_response_model.dart';
import 'package:dartz/dartz.dart'; // Untuk Either

// Import ServiceHttpClient Anda yang sudah direvisi
import 'package:barbergo_mobile/service/service_http_client.dart'; // SESUAIKAN PATH INI



class AdminRepository {
  final ServiceHttpClient httpClient;

  AdminRepository(this.httpClient);

  /// Mengambil semua data pemesanan (bookings) untuk admin.
  /// Endpoint API yang diasumsikan: /admin/pemesanan
  Future<Either<String, List<PemesananData>>> getAllPemesanan() async {
    try {
      // Panggil getWithToken dari ServiceHttpClient
      final response = await httpClient.getWithToken('admin/pemesanan');

      // Periksa status code sukses
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Dekode body respons dari string JSON ke Map<String, dynamic>
        final Map<String, dynamic> responseData = json.decode(response.body);

        final GetAllAdminPemesananResponseModel model = GetAllAdminPemesananResponseModel.fromMap(responseData);
        if (model.data != null) {
          return Right(model.data!);
        } else {
          return Left(model.message ?? 'No booking data found for admin or data is empty.');
        }
      } else {
        // Tangani error berdasarkan status code atau body respons
        String errorMessage = 'Failed to load admin bookings. Status code: ${response.statusCode}.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          // Gagal mendekode body error, gunakan pesan default
          print('Error decoding error response body for admin bookings: $e');
        }
        return Left(errorMessage);
      }
    } catch (e) {
      // Tangkap Exception yang dilempar dari ServiceHttpClient (misalnya masalah jaringan)
      // e.toString() akan menghasilkan "Exception: GET request failed: ..."
      return Left(e.toString().replaceFirst('Exception: ', '')); // Membersihkan pesan
    }
  }

  /// Mengambil semua data pembayaran (payments) untuk admin.
  /// Endpoint API yang diasumsikan: /admin/pembayaran
  Future<Either<String, List<PembayaranData>>> getAllPembayaran() async {
    try {
      // Panggil getWithToken dari ServiceHttpClient
      final response = await httpClient.getWithToken('admin/pembayaran');

      // Periksa status code sukses
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Dekode body respons dari string JSON ke Map<String, dynamic>
        final Map<String, dynamic> responseData = json.decode(response.body);

        final GetAllAdminPembayaranResponseModel model = GetAllAdminPembayaranResponseModel.fromMap(responseData);
        if (model.data != null) {
          return Right(model.data!);
        } else {
          // Jika data kosong tapi status 200, return pesan dari API atau default
          return Left(model.message ?? 'No payment data found for admin or data is empty.');
        }
      } else {
        // Tangani error berdasarkan status code atau body respons
        String errorMessage = 'Failed to load admin payments. Status code: ${response.statusCode}.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          // Gagal mendekode body error, gunakan pesan default
          print('Error decoding error response body for admin payments: $e');
        }
        return Left(errorMessage);
      }
    } catch (e) {
      // Tangkap Exception yang dilempar dari ServiceHttpClient
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }

 Future<Either<String, String>> updatePemesananStatus(int id, String status) async {
    try {
      final response = await httpClient.putWithToken(
        'pemesanan/status/$id', // <-- REVISI PENTING DI SINI: Gunakan interpolasi string untuk ID
        {'status': status},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Right(responseData['message'] ?? 'Booking status updated successfully');
      } else {
        String errorMessage = 'Failed to update booking status. Status code: ${response.statusCode}.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          log('Error decoding error response body for update booking status: $e');
        }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }
  // Anda bisa menambahkan method lain di sini untuk operasi admin lainnya

   /// Endpoint API yang diasumsikan: admin/pembayaran/status/{id}
  Future<Either<String, String>> updatePembayaranStatus(int id, String status) async {
    try {
      final response = await httpClient.putWithToken(
        'admin/pembayaran/status/$id', // Menggunakan rute yang sesuai
        {'status': status},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Right(responseData['message'] ?? 'Payment status updated successfully');
      } else {
        String errorMessage = 'Failed to update payment status. Status code: ${response.statusCode}.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          log('Error decoding error response body for update payment status: $e');
        }
        return Left(errorMessage);
      }
    } catch (e) {
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}