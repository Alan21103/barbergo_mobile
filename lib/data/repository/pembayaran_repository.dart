// lib/data/repository/pembayaran_repository.dart

import 'dart:convert';
import 'dart:developer';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart'; // Untuk Either
import 'package:http/http.dart' as http; // Untuk http.Response

// Import models yang relevan
import 'package:barbergo_mobile/data/model/request/pembayaran/pembayaran_request_model.dart'; // Model request untuk store
import 'package:barbergo_mobile/data/model/response/pembayaran/pembayaran_response_model.dart'; // Model response untuk store
import 'package:barbergo_mobile/data/model/response/pembayaran/get_all_pembayaran_response_model.dart'; // Model response untuk get all

class PembayaranRepository {
  final ServiceHttpClient _serviceHttpClient;

  PembayaranRepository(this._serviceHttpClient);

  /// Membuat pembayaran baru.
  /// Mengirim [PembayaranRequestModel] ke server.
  /// Mengembalikan [PembayaranResponseModel] jika berhasil atau pesan error jika gagal.
  Future<Either<String, PembayaranResponseModel>> createPembayaran(
      PembayaranRequestModel requestModel) async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.postWithToken(
        'pelanggan/pembayaran', // Endpoint API untuk membuat pembayaran
        requestModel.toJson(), // Mengirim body dalam format JSON string
      );

      log("PembayaranRepository: createPembayaran - Status Code: ${response.statusCode}");
      log("PembayaranRepository: createPembayaran - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final pembayaranResponse = PembayaranResponseModel.fromMap(jsonResponse);
        log("PembayaranRepository: createPembayaran successful: ${pembayaranResponse.message}");
        return Right(pembayaranResponse);
      } else {
        log("PembayaranRepository: createPembayaran failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(
            jsonResponse['message'] ?? "Create Pembayaran failed: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("PembayaranRepository: FormatException in createPembayaran: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("PembayaranRepository: Error in createPembayaran: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat pembayaran: $e");
    }
  }

  /// Mengambil daftar semua pembayaran.
  /// Mengembalikan [GetAllPembayaranResponseModel] jika berhasil atau pesan error jika gagal.
  Future<Either<String, GetAllPembayaranResponseModel>> getAllPembayaran() async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.getWithToken('pelanggan/pembayarans'); // Endpoint API untuk mendapatkan semua pembayaran

      log("PembayaranRepository: getAllPembayaran - Status Code: ${response.statusCode}");
      log("PembayaranRepository: getAllPembayaran - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final GetAllPembayaranResponseModel fullResponse =
            GetAllPembayaranResponseModel.fromJson(response.body);
        log("PembayaranRepository: getAllPembayaran successful: ${fullResponse.data?.length ?? 0} items");
        return Right(fullResponse);
      } else {
        log("PembayaranRepository: getAllPembayaran failed: ${json.decode(response.body)['message'] ?? 'Unknown error'}");
        return Left(
            json.decode(response.body)['message'] ?? "Get All Pembayaran failed: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("PembayaranRepository: FormatException in getAllPembayaran: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("PembayaranRepository: Error in getAllPembayaran: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mengambil daftar pembayaran: $e");
    }
  }
}
