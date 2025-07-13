import 'dart:convert';
import 'dart:developer';
import 'package:barbergo_mobile/data/model/request/portofolio/portofolio_request_model.dart';
import 'package:barbergo_mobile/data/model/response/portofolios/get_all_portofolios_response_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../model/response/portofolios/portofolio_response_model.dart';

class PortofolioRepository {
  final ServiceHttpClient _serviceHttpClient;

  PortofolioRepository(this._serviceHttpClient);

  /// Mengambil daftar semua portofolio.
  /// Mengembalikan [List<PortofolioDatum>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<PortofolioDatum>>> getAllPortofolios() async {
    http.Response? response;
    final String endpoint = 'portofolios'; // Definisikan endpoint untuk logging

    try {
      log("Memulai permintaan GET untuk portofolio di endpoint: ${
          _serviceHttpClient.baseUrl ?? '[BASE_URL_UNDEFINED]'
        }/$endpoint");

      response = await _serviceHttpClient.getWithToken(endpoint);

      log("Menerima respons untuk portofolio. Status Code: ${response.statusCode}");
      log("Respons Headers (Content-Type): ${response.headers['content-type']}");
      log("Respons Body (Mentah): ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}"); // Batasi ukuran log body

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Server mengembalikan respons non-JSON untuk portofolio. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType.");
      }

      if (response.statusCode == 200) {
        final GetAllPortofoliosResponseModel fullResponse =
            GetAllPortofoliosResponseModel.fromJson(response.body);

        log("Get All Portofolios berhasil. Jumlah item: ${fullResponse.data?.length ?? 0}");
        // Log detail URL gambar untuk setiap portofolio (ambil beberapa contoh)
        if (fullResponse.data != null && fullResponse.data!.isNotEmpty) {
          log("Detail 3 Portofolio Pertama (URL Gambar):");
          for (int i = 0; i < fullResponse.data!.length && i < 3; i++) {
            log("  Portofolio ${i + 1} ID: ${fullResponse.data![i].id}, Image URL: ${fullResponse.data![i].image ?? 'N/A'}");
            // Anda bisa tambahkan logging untuk field lain juga jika diperlukan
          }
        }

        return Right(fullResponse.data ?? []);
      } else {
        // Respons non-200 (error dari server)
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        final statusCode = jsonResponse['status_code'] ?? response.statusCode; // Ambil status_code jika ada
        log("Get All Portofolios gagal. Pesan: $errorMessage. Status HTTP: ${response.statusCode}. Status Kode API: $statusCode");
        return Left(errorMessage);
      }
    } on http.ClientException catch (e) {
      // Penanganan error jaringan spesifik (e.g., Connection refused, Host lookup failed)
      log("HTTP Client Error saat mendapatkan portofolio: $e", error: e);
      return Left("Kesalahan koneksi jaringan: Pastikan server berjalan dan URL benar. Detail: $e");
    } on FormatException catch (e) {
      // Penanganan error parsing JSON
      log("FormatException dalam mendapatkan portofolio: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      // Penanganan error umum lainnya
      log("Error tak terduga dalam mendapatkan portofolio: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan portofolio: $e");
    }
  }

  /// Mengambil daftar portofolio milik barber yang sedang login.
  /// Mengembalikan [List<PortofolioDatum>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<PortofolioDatum>>> getMyPortofolios() async {
    http.Response? response;
    final String endpoint = 'my-portofolios';

    try {
      log("Memulai permintaan GET untuk portofolio saya di endpoint: ${
          _serviceHttpClient.baseUrl ?? '[BASE_URL_UNDEFINED]'
        }/$endpoint");

      response = await _serviceHttpClient.getWithToken(endpoint);

      log("Menerima respons untuk portofolio saya. Status Code: ${response.statusCode}");
      log("Respons Headers (Content-Type): ${response.headers['content-type']}");
      log("Respons Body (Mentah): ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Server mengembalikan respons non-JSON untuk portofolio saya. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType.");
      }

      if (response.statusCode == 200) {
        final GetAllPortofoliosResponseModel fullResponse =
            GetAllPortofoliosResponseModel.fromJson(response.body);

        log("Get My Portofolios berhasil. Jumlah item: ${fullResponse.data?.length ?? 0}");
        if (fullResponse.data != null && fullResponse.data!.isNotEmpty) {
          log("Detail 3 Portofolio Pertama Saya (URL Gambar):");
          for (int i = 0; i < fullResponse.data!.length && i < 3; i++) {
            log("   Portofolio ${i + 1} ID: ${fullResponse.data![i].id}, Image URL: ${fullResponse.data![i].image ?? 'N/A'}");
          }
        }

        return Right(fullResponse.data ?? []);
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        final statusCode = jsonResponse['status_code'] ?? response.statusCode;
        log("Get My Portofolios gagal. Pesan: $errorMessage. Status HTTP: ${response.statusCode}. Status Kode API: $statusCode");
        return Left(errorMessage);
      }
    } on http.ClientException catch (e) {
      log("HTTP Client Error saat mendapatkan portofolio saya: $e", error: e);
      return Left("Kesalahan koneksi jaringan: Pastikan server berjalan dan URL benar. Detail: $e");
    } on FormatException catch (e) {
      log("FormatException dalam mendapatkan portofolio saya: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error tak terduga dalam mendapatkan portofolio saya: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan portofolio saya: $e");
    }
  }

  /// Membuat portofolio baru.
  /// Mengembalikan [Data] (objek portofolio yang dibuat) jika berhasil atau pesan error jika gagal.
  Future<Either<String, Data>> createPortofolio(PortofolioRequestModel requestModel) async {
    http.Response? response;
    final String endpoint = 'my-portofolios';

    try {
      log("Memulai permintaan POST untuk membuat portofolio di endpoint: ${
          _serviceHttpClient.baseUrl ?? '[BASE_URL_UNDEFINED]'
        }/$endpoint");
      log("Request Body: ${requestModel.toMap()}"); // Log body yang akan dikirim

      // Mengirimkan body sebagai JSON karena image adalah String (Base64/URL)
      response = await _serviceHttpClient.postWithToken(endpoint, requestModel.toMap());

      log("Menerima respons untuk pembuatan portofolio. Status Code: ${response.statusCode}");
      log("Respons Headers (Content-Type): ${response.headers['content-type']}");
      log("Respons Body (Mentah): ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Server mengembalikan respons non-JSON saat membuat portofolio. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType.");
      }

      if (response.statusCode == 201) { // 201 Created
        final PortofolioResponseModel portfolioResponse = PortofolioResponseModel.fromJson(response.body);
        if (portfolioResponse.data != null) {
          log("Create Portofolio berhasil. ID: ${portfolioResponse.data!.id}");
          return Right(portfolioResponse.data!);
        } else {
          log("Create Portofolio gagal: Data respons kosong.");
          return Left(portfolioResponse.message ?? "Gagal membuat portofolio: Data respons kosong.");
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        final statusCode = jsonResponse['status_code'] ?? response.statusCode;
        log("Create Portofolio gagal. Pesan: $errorMessage. Status HTTP: ${response.statusCode}. Status Kode API: $statusCode");
        return Left(errorMessage);
      }
    } on http.ClientException catch (e) {
      log("HTTP Client Error saat membuat portofolio: $e", error: e);
      return Left("Kesalahan koneksi jaringan: Pastikan server berjalan dan URL benar. Detail: $e");
    } on FormatException catch (e) {
      log("FormatException dalam membuat portofolio: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error tak terduga dalam membuat portofolio: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat portofolio: $e");
    }
  }

  /// Memperbarui portofolio yang sudah ada.
  /// Mengembalikan [Data] (objek portofolio yang diperbarui) jika berhasil atau pesan error jika gagal.
  Future<Either<String, Data>> updatePortofolio(int id, PortofolioRequestModel requestModel) async {
    http.Response? response;
    final String endpoint = 'my-portofolios/$id';

    try {
      log("Memulai permintaan PUT untuk memperbarui portofolio di endpoint: ${
          _serviceHttpClient.baseUrl ?? '[BASE_URL_UNDEFINED]'
        }/$endpoint");
      log("Request Body: ${requestModel.toMap()}"); // Log body yang akan dikirim

      // Mengirimkan body sebagai JSON karena image adalah String (Base64/URL)
      response = await _serviceHttpClient.putWithToken(endpoint, requestModel.toMap());

      log("Menerima respons untuk pembaruan portofolio. Status Code: ${response.statusCode}");
      log("Respons Headers (Content-Type): ${response.headers['content-type']}");
      log("Respons Body (Mentah): ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Server mengembalikan respons non-JSON saat memperbarui portofolio. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType.");
      }

      if (response.statusCode == 200) {
        final PortofolioResponseModel portfolioResponse = PortofolioResponseModel.fromJson(response.body);
        if (portfolioResponse.data != null) {
          log("Update Portofolio berhasil. ID: ${portfolioResponse.data!.id}");
          return Right(portfolioResponse.data!);
        } else {
          log("Update Portofolio gagal: Data respons kosong.");
          return Left(portfolioResponse.message ?? "Gagal memperbarui portofolio: Data respons kosong.");
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        final statusCode = jsonResponse['status_code'] ?? response.statusCode;
        log("Update Portofolio gagal. Pesan: $errorMessage. Status HTTP: ${response.statusCode}. Status Kode API: $statusCode");
        return Left(errorMessage);
      }
    } on http.ClientException catch (e) {
      log("HTTP Client Error saat memperbarui portofolio: $e", error: e);
      return Left("Kesalahan koneksi jaringan: Pastikan server berjalan dan URL benar. Detail: $e");
    } on FormatException catch (e) {
      log("FormatException dalam memperbarui portofolio: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error tak terduga dalam memperbarui portofolio: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat memperbarui portofolio: $e");
    }
  }

  /// Menghapus portofolio.
  /// Mengembalikan [String] pesan sukses jika berhasil atau pesan error jika gagal.
  Future<Either<String, String>> deletePortofolio(int id) async {
    http.Response? response;
    final String endpoint = 'my-portofolios/$id';

    try {
      log("Memulai permintaan DELETE untuk menghapus portofolio di endpoint: ${
          _serviceHttpClient.baseUrl ?? '[BASE_URL_UNDEFINED]'
        }/$endpoint");

      response = await _serviceHttpClient.deleteWithToken(endpoint);

      log("Menerima respons untuk penghapusan portofolio. Status Code: ${response.statusCode}");
      log("Respons Headers (Content-Type): ${response.headers['content-type']}");
      log("Respons Body (Mentah): ${response.body.length > 500 ? response.body.substring(0, 500) + '...' : response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        log("Server mengembalikan respons non-JSON saat menghapus portofolio. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
        return Left(
            "Server mengembalikan respons non-JSON. Diharapkan application/json, tetapi mendapatkan: $contentType.");
      }

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final String message = jsonResponse['message'] ?? 'Portofolio berhasil dihapus';
        log("Delete Portofolio berhasil: $message");
        return Right(message);
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        final statusCode = jsonResponse['status_code'] ?? response.statusCode;
        log("Delete Portofolio gagal. Pesan: $errorMessage. Status HTTP: ${response.statusCode}. Status Kode API: $statusCode");
        return Left(errorMessage);
      }
    } on http.ClientException catch (e) {
      log("HTTP Client Error saat menghapus portofolio: $e", error: e);
      return Left("Kesalahan koneksi jaringan: Pastikan server berjalan dan URL benar. Detail: $e");
    } on FormatException catch (e) {
      log("FormatException dalam menghapus portofolio: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error tak terduga dalam menghapus portofolio: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat menghapus portofolio: $e");
    }
  }
}