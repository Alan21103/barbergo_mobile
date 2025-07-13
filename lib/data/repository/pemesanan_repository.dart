import 'dart:convert';
import 'dart:developer'; // Untuk log
import 'package:barbergo_mobile/data/model/response/pemesanan/get_all_pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/request/pemesanan/pemesanan_request_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/data/model/response/pemesanan/pemesanan_response_model.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart'; // Untuk Either
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PemesananRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  PemesananRepository(this._serviceHttpClient);

  // --- CRUD Operations ---

  Future<Either<String, PemesananResponseModel>> createPemesanan(
    PemesananRequestModel requestModel,
  ) async {
    http.Response? response; // Deklarasikan response di luar try block
    try {
      response = await _serviceHttpClient.postWithToken(
        'pelanggan/pemesanan',
        requestModel.toJson(),
      );

      log("Response status code for createPemesanan: ${response.statusCode}");
      log("Response headers for createPemesanan: ${response.headers}");
      log("Response body for createPemesanan: ${response.body}");

      // --- Perbaikan: Tangani status kode 302 (Redirect) secara eksplisit ---
      if (response.statusCode == 302) {
        return Left(
          "Permintaan dialihkan oleh server. Pastikan endpoint POST tidak melakukan redirect. Lokasi redirect: ${response.headers['location'] ?? 'Tidak diketahui'}",
        );
      }

      // Cek Content-Type header
      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
          "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}",
        );
      }

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        final pemesananResponse = PemesananResponseModel.fromMap(jsonResponse);
        log("Create Pemesanan successful: ${pemesananResponse.message}");
        return Right(pemesananResponse);
      } else {
        log(
          "Create Pemesanan failed: ${jsonResponse['message'] ?? 'Unknown error'}",
        );
        return Left(
          jsonResponse['message'] ??
              "Create Pemesanan failed: Server mengembalikan ${response.statusCode}",
        );
      }
    } on FormatException catch (e) {
      log(
        "FormatException in creating pemesanan: $e. Body: ${response?.body ?? 'Response body not available'}",
      );
      return Left(
        "Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e",
      );
    } catch (e) {
      log("Error in creating pemesanan: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat pemesanan: $e");
    }
  }

  /// Mengambil daftar semua pemesanan.
  /// Mengembalikan [GetAllPemesananResponseModel] jika berhasil atau pesan error jika gagal.
  Future<Either<String, GetAllPemesananResponseModel>>
  getPemesananList() async {
    try {
      final response = await _serviceHttpClient.getWithToken(
        'pelanggan/pemesanan',
      );

      if (response.statusCode == 200) {
        final GetAllPemesananResponseModel fullResponse =
            GetAllPemesananResponseModel.fromJson(response.body);

        log(
          "Get Pemesanan List successful: Status Code: ${fullResponse.statusCode}, Message: ${fullResponse.message}, Data Count: ${fullResponse.data?.length ?? 0} items",
        );
        return Right(fullResponse);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get Pemesanan List failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Get Pemesanan List failed");
      }
    } catch (e) {
      log("Error in getting pemesanan list: $e");
      return Left("An error occurred while getting pemesanan list: $e");
    }
  }

  /// Mengambil detail pemesanan berdasarkan ID.
  /// Mengembalikan objek [Datum] pemesanan jika berhasil atau pesan error jika gagal.
  Future<Either<String, Datum>> getPemesananById(String id) async {
    try {
      final response = await _serviceHttpClient.getWithToken(
        'pelanggan/pemesanan/$id',
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final Datum pemesananDetail = Datum.fromMap(jsonResponse['data']);
        log("Get Pemesanan by ID successful: ID ${pemesananDetail.id}");
        return Right(pemesananDetail);
      } else if (response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        log("Pemesanan with ID $id not found: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Pemesanan not found.");
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get Pemesanan by ID failed: ${jsonResponse['message']}");
        return Left(
          jsonResponse['message'] ?? "Failed to load pemesanan detail.",
        );
      }
    } catch (e) {
      log("Error in getting pemesanan by ID $id: $e");
      if (e.toString().contains('FormatException: Unexpected character')) {
        return const Left(
          "Terjadi kesalahan format data dari server. Coba lagi atau hubungi dukungan.",
        );
      }
      return Left("An error occurred while getting pemesanan by ID: $e");
    }
  }

  /// Memperbarui pemesanan yang sudah ada berdasarkan ID.
  /// Mengirim [PemesananRequestModel] yang berisi data yang diperbarui.
  /// Mengembalikan [PemesananResponseModel] jika berhasil atau pesan error jika gagal.
  Future<Either<String, PemesananResponseModel>> updatePemesanan(
    int id,
    PemesananRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.putWithToken(
        'pelanggan/pemesanan/$id',
        requestModel.toMap(),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final pemesananResponse = PemesananResponseModel.fromMap(jsonResponse);
        log("Update Pemesanan successful: ${pemesananResponse.message}");
        return Right(pemesananResponse);
      } else {
        log("Update Pemesanan failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Update Pemesanan failed");
      }
    } catch (e) {
      log("Error in updating pemesanan $e");
      return Left("An error occurred while updating pemesanan: $e");
    }
  }

  /// Menghapus pemesanan berdasarkan ID.
  /// Mengembalikan pesan sukses jika berhasil atau pesan error jika gagal.
  Future<Either<String, String>> deletePemesanan(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken(
        'pelanggan/pemesanan/$id',
      );

      if (response.statusCode == 200) {
        log("Delete Pemesanan successful");
        return Right("Pemesanan deleted successfully");
      } else {
        final jsonResponse = json.decode(response.body);
        log("Delete Pemesanan failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Delete Pemesanan failed");
      }
    } catch (e) {
      log("Error in deleting pemesanan $e");
      return Left("An error occurred while deleting pemesanan: $e");
    }
  }

  Future<Either<String, String>> cancelPemesanan(String id) async {
    try {
      final response = await _serviceHttpClient.putWithToken(
        'pemesanan/status/$id',
        {
          'status':
              'cancelled', // <-- INI PERBAIKAN UTAMANYA! Kirim status 'cancelled'
        },
      );

      if (response.statusCode == 200) {
        log("Cancel Pemesanan successful");
        final jsonResponse = json.decode(response.body);
        return Right(jsonResponse['message'] ?? "Pesanan berhasil dibatalkan");
      } else {
        // Tangani respons non-200
        try {
          // Coba parse body sebagai JSON
          final jsonResponse = json.decode(response.body);
          log(
            "Cancel Pemesanan failed: ${jsonResponse['message'] ?? response.statusCode}",
          );
          return Left(
            jsonResponse['message'] ??
                "Cancel Pemesanan failed: Unknown reason (Status: ${response.statusCode})",
          );
        } catch (e2) {
          // Jika body bukan JSON, ini adalah kasus HTML yang Anda alami
          log(
            "Cancel Pemesanan failed: Non-JSON response received, Status: ${response.statusCode}, Body: ${response.body}",
          );
          return Left(
            "Cancel Pemesanan failed: Server returned unexpected format (Status: ${response.statusCode}). Backend returned HTML. Check authentication or route.",
          );
        }
      }
    } catch (e) {
      log("Error in canceling pemesanan: $e");
      if (e.toString().contains('FormatException: Unexpected character')) {
        return const Left(
          "Terjadi kesalahan format data dari server. Server mengembalikan HTML. Pastikan token valid dan URL benar.",
        );
      }
      return Left("An error occurred while canceling pemesanan: $e");
    }
  }

  /// Mengambil daftar semua layanan yang tersedia.
  /// Mengembalikan [List<GetAllServiceModel>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<GetAllServiceModel>>> getServices() async {
    try {
      final response = await _serviceHttpClient.getWithToken(
        'services',
      ); // Sesuaikan endpoint API Anda
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(
          response.body,
        ); // Decode to dynamic

        List<dynamic> dataList;
        if (decodedResponse is List) {
          // Jika respons langsung berupa list
          dataList = decodedResponse;
        } else if (decodedResponse is Map &&
            decodedResponse.containsKey('data')) {
          // Jika respons berupa map dengan kunci 'data'
          dataList = decodedResponse['data'];
        } else {
          // Tangani struktur respons yang tidak terduga
          return Left("Unexpected response structure for services.");
        }

        final List<GetAllServiceModel> services =
            dataList.map((e) => GetAllServiceModel.fromMap(e)).toList();
        log("Get Services successful: ${services.length} items");
        return Right(services);
      } else {
        final jsonResponse = json.decode(response.body);
        log(
          "Get Services failed: ${jsonResponse['message'] ?? 'Unknown error'}",
        );
        return Left(
          jsonResponse['message'] ??
              "Failed to load services: Server returned ${response.statusCode}",
        );
      }
    } catch (e) {
      log("Error in getting services: $e", error: e);
      return Left("An error occurred while getting services: $e");
    }
  }

  /// Mengambil daftar semua tukang cukur (admin) yang tersedia.
  /// Mengembalikan [List<AdminDatum>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<AdminDatum>>> getBarbers() async {
    try {
      final response = await _serviceHttpClient.getWithToken(
        'admin/profiles',
      ); // Sesuaikan endpoint API Anda
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> dataList = jsonResponse['data'] ?? [];
        final List<AdminDatum> barbers =
            dataList.map((e) => AdminDatum.fromMap(e)).toList();
        log("Get Barbers successful: ${barbers.length} items");
        return Right(barbers);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get Barbers failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Failed to load barbers.");
      }
    } catch (e) {
      log("Error in getting barbers: $e", error: e);
      return Left("An error occurred while getting barbers: $e");
    }
  }

  Future<Either<String, PelangganProfileResponseModel>> getUserProfile() async {
    http.Response? response;
    try {
      // Asumsi endpoint untuk mendapatkan profil pelanggan yang sedang login
      response = await _serviceHttpClient.getWithToken('pelanggan/profile'); // Sesuaikan dengan endpoint API Anda

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON untuk profil pelanggan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        // PERBAIKAN: Dekode body terlebih dahulu menjadi Map<String, dynamic>
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // PERBAIKAN: Panggil fromJson karena itu yang menerima Map<String, dynamic>
        final PelangganProfileResponseModel profile = PelangganProfileResponseModel.fromJson(jsonResponse); 
        log("Get User Profile successful: ${profile.data.name}");
        return Right(profile);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get User Profile failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal memuat profil pelanggan: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam mendapatkan profil pelanggan: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server untuk profil pelanggan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam mendapatkan profil pelanggan: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan profil pelanggan: $e");
    }
  }
}
