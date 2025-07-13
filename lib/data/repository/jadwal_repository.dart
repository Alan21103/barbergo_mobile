import 'dart:convert';
import 'dart:developer';
import 'package:barbergo_mobile/data/model/response/jadwal/get_all_jadwal_response_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class JadwalRepository {
  final ServiceHttpClient _serviceHttpClient;

  JadwalRepository(this._serviceHttpClient);

  /// Mengambil daftar semua jadwal yang tersedia (untuk semua barber).
  /// Mengembalikan [List<JadwalDatum>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<JadwalDatum>>> getBarberSchedules() async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.getWithToken('jadwals');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON untuk semua jadwal. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final GetAllJadwalResponseModel fullResponse =
            GetAllJadwalResponseModel.fromJson(response.body);

        log("Get All Jadwal successful: ${fullResponse.data?.length ?? 0} items");
        return Right(fullResponse.data ?? []);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get All Jadwal failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal memuat semua jadwal: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam mendapatkan semua jadwal: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server untuk semua jadwal. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam mendapatkan semua jadwal: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan semua jadwal: $e");
    }
  }

  /// Mengambil daftar jadwal milik barber yang sedang login.
  /// Mengembalikan [List<JadwalDatum>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<JadwalDatum>>> getMyJadwal() async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.getWithToken('my-jadwal');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON untuk jadwal saya. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final GetAllJadwalResponseModel fullResponse =
            GetAllJadwalResponseModel.fromJson(response.body);

        log("Get My Jadwal successful: ${fullResponse.data?.length ?? 0} items");
        return Right(fullResponse.data ?? []);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Get My Jadwal failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal memuat jadwal saya: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam mendapatkan jadwal saya: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server untuk jadwal saya. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam mendapatkan jadwal saya: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan jadwal saya: $e");
    }
  }

  /// Membuat jadwal baru untuk barber yang sedang login.
  /// Membutuhkan [data] berupa Map<String, dynamic> yang berisi 'hari', 'tersedia_dari', 'tersedia_hingga'.
  /// Mengembalikan [JadwalDatum] jika berhasil atau pesan error jika gagal.
  Future<Either<String, JadwalDatum>> createMyJadwal(Map<String, dynamic> data) async {
    http.Response? response;
    try {
      // Memanggil endpoint 'my-jadwal' untuk membuat jadwal barber yang sedang login
      response = await _serviceHttpClient.postWithToken('my-jadwal', data);

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON saat membuat jadwal. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 201) { // 201 Created
        final jsonResponse = json.decode(response.body);
        final JadwalDatum newJadwal = JadwalDatum.fromJson(jsonResponse['data']);
        log("Create My Jadwal successful: ${newJadwal.id}");
        return Right(newJadwal);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Create My Jadwal failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal membuat jadwal: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam membuat jadwal: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server saat membuat jadwal. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam membuat jadwal: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat jadwal: $e");
    }
  }

  /// Memperbarui jadwal tertentu milik barber yang sedang login.
  /// Membutuhkan [id] jadwal dan [data] berupa Map<String, dynamic> untuk diperbarui.
  /// Mengembalikan [JadwalDatum] yang diperbarui jika berhasil atau pesan error jika gagal.
  Future<Either<String, JadwalDatum>> updateMyJadwal(int id, Map<String, dynamic> data) async {
    http.Response? response;
    try {
      // Memanggil endpoint 'my-jadwal/$id' untuk memperbarui jadwal barber yang sedang login
      response = await _serviceHttpClient.putWithToken('my-jadwal/$id', data);

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON saat memperbarui jadwal. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final JadwalDatum updatedJadwal = JadwalDatum.fromJson(jsonResponse['data']);
        log("Update My Jadwal successful: ${updatedJadwal.id}");
        return Right(updatedJadwal);
      } else {
        final jsonResponse = json.decode(response.body);
        log("Update My Jadwal failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal memperbarui jadwal: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam memperbarui jadwal: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server saat memperbarui jadwal. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam memperbarui jadwal: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat memperbarui jadwal: $e");
    }
  }

  /// Menghapus jadwal tertentu milik barber yang sedang login.
  /// Membutuhkan [id] jadwal yang akan dihapus.
  /// Mengembalikan [String] pesan sukses jika berhasil atau pesan error jika gagal.
  Future<Either<String, String>> deleteMyJadwal(int id) async {
    http.Response? response;
    try {
      // Memanggil endpoint 'my-jadwal/$id' untuk menghapus jadwal barber yang sedang login
      response = await _serviceHttpClient.deleteWithToken('my-jadwal/$id');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left("Server mengembalikan respons non-JSON saat menghapus jadwal. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log("Delete My Jadwal successful: ${jsonResponse['message'] ?? 'Jadwal berhasil dihapus'}");
        return Right(jsonResponse['message'] ?? 'Jadwal berhasil dihapus');
      } else {
        final jsonResponse = json.decode(response.body);
        log("Delete My Jadwal failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal menghapus jadwal: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("FormatException dalam menghapus jadwal: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}");
      return Left("Terjadi kesalahan format data dari server saat menghapus jadwal. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("Error dalam menghapus jadwal: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat menghapus jadwal: $e");
    }
  }
}
