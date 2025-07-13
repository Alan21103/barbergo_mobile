// lib/data/repository/service_repository.dart
import 'dart:convert';
import 'dart:developer'; // Untuk log
import 'package:barbergo_mobile/data/model/request/service/service_request_model.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart'; // Import model
import 'package:barbergo_mobile/data/model/response/services/service_response_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart'; // Untuk Either
import 'package:http/http.dart' as http; // Untuk http.Response

class ServiceRepository {
  final ServiceHttpClient _serviceHttpClient;

  ServiceRepository(this._serviceHttpClient);

  /// Mengambil daftar semua layanan yang tersedia.
  /// Mengembalikan [List<GetAllServiceModel>] jika berhasil atau pesan error jika gagal.
  Future<Either<String, List<GetAllServiceModel>>> getServices() async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.getWithToken(
          'services'); // Sesuaikan endpoint API Anda

      log("ServiceRepository: getServices - Status Code: ${response.statusCode}");
      log("ServiceRepository: getServices - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON untuk layanan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      final dynamic decodedResponse = json.decode(response.body); // Decode to dynamic

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
      log("ServiceRepository: getServices successful: ${services.length} items");
      return Right(services);
    } on FormatException catch (e) {
      log("ServiceRepository: FormatException in getServices: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server untuk layanan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("ServiceRepository: Error in getServices: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan layanan: $e");
    }
  }

  Future<Either<String, List<GetAllServiceModel>>> getMyServices() async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.getWithToken('my-services'); // Endpoint untuk layanan saya

      log("ServiceRepository: getMyServices - Status Code: ${response.statusCode}");
      log("ServiceRepository: getMyServices - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON untuk layanan saya. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      final dynamic decodedResponse = json.decode(response.body);

      List<dynamic> dataList;
      if (decodedResponse is List) {
        dataList = decodedResponse;
      } else if (decodedResponse is Map && decodedResponse.containsKey('data')) {
        dataList = decodedResponse['data'];
      } else {
        return Left("Unexpected response structure for my services.");
      }

      final List<GetAllServiceModel> services =
          dataList.map((e) => GetAllServiceModel.fromMap(e)).toList();
      log("ServiceRepository: getMyServices successful: ${services.length} items");
      return Right(services);
    } on FormatException catch (e) {
      log("ServiceRepository: FormatException in getMyServices: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server untuk layanan saya. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("ServiceRepository: Error in getMyServices: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat mendapatkan layanan saya: $e");
    }
  }

  /// Membuat layanan baru untuk barber yang sedang login.
  /// Mengembalikan [Data] (objek layanan yang dibuat) jika berhasil atau pesan error jika gagal.
  Future<Either<String, Data>> createService(ServiceRequestModel requestModel) async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.postWithToken('my-services', requestModel.toMap()); // Endpoint POST untuk layanan saya

      log("ServiceRepository: createService - Status Code: ${response.statusCode}");
      log("ServiceRepository: createService - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat membuat layanan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 201) { // 201 Created
        final ServiceResponseModel serviceResponse = ServiceResponseModel.fromJson(response.body);
        if (serviceResponse.data != null) {
          log("ServiceRepository: createService successful: ${serviceResponse.data!.id}");
          return Right(serviceResponse.data!);
        } else {
          return Left(serviceResponse.message ?? "Gagal membuat layanan: Data respons kosong.");
        }
      } else {
        final ServiceResponseModel serviceResponse = ServiceResponseModel.fromJson(response.body);
        log("ServiceRepository: createService failed: ${serviceResponse.message ?? 'Unknown error'}");
        return Left(serviceResponse.message ?? "Gagal membuat layanan: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("ServiceRepository: FormatException in createService: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server saat membuat layanan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("ServiceRepository: Error in createService: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat layanan: $e");
    }
  }

  /// Memperbarui layanan tertentu milik barber yang sedang login.
  /// Mengembalikan [Data] (objek layanan yang diperbarui) jika berhasil atau pesan error jika gagal.
  Future<Either<String, Data>> updateService(int id, ServiceRequestModel requestModel) async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.putWithToken('my-services/$id', requestModel.toMap()); // Endpoint PUT untuk layanan saya

      log("ServiceRepository: updateService - Status Code: ${response.statusCode}");
      log("ServiceRepository: updateService - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat memperbarui layanan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final ServiceResponseModel serviceResponse = ServiceResponseModel.fromJson(response.body);
        if (serviceResponse.data != null) {
          log("ServiceRepository: updateService successful: ${serviceResponse.data!.id}");
          return Right(serviceResponse.data!);
        } else {
          return Left(serviceResponse.message ?? "Gagal memperbarui layanan: Data respons kosong.");
        }
      } else {
        final ServiceResponseModel serviceResponse = ServiceResponseModel.fromJson(response.body);
        log("ServiceRepository: updateService failed: ${serviceResponse.message ?? 'Unknown error'}");
        return Left(serviceResponse.message ?? "Gagal memperbarui layanan: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("ServiceRepository: FormatException in updateService: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server saat memperbarui layanan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("ServiceRepository: Error in updateService: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat memperbarui layanan: $e");
    }
  }

  /// Menghapus layanan tertentu milik barber yang sedang login.
  /// Mengembalikan [String] pesan sukses jika berhasil atau pesan error jika gagal.
  Future<Either<String, String>> deleteService(int id) async {
    http.Response? response;
    try {
      response = await _serviceHttpClient.deleteWithToken('my-services/$id'); // Endpoint DELETE untuk layanan saya

      log("ServiceRepository: deleteService - Status Code: ${response.statusCode}");
      log("ServiceRepository: deleteService - Response Body: ${response.body}");

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat menghapus layanan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final String message = jsonResponse['message'] ?? 'Layanan berhasil dihapus';
        log("ServiceRepository: deleteService successful: $message");
        return Right(message);
      } else {
        final dynamic jsonResponse = json.decode(response.body);
        log("ServiceRepository: deleteService failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        return Left(jsonResponse['message'] ?? "Gagal menghapus layanan: Server mengembalikan ${response.statusCode}");
      }
    } on FormatException catch (e) {
      log("ServiceRepository: FormatException in deleteService: $e. Body: ${response?.body ?? 'Response body not available'}");
      return Left("Terjadi kesalahan format data dari server saat menghapus layanan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log("ServiceRepository: Error in deleteService: $e", error: e);
      return Left("Terjadi kesalahan tak terduga saat menghapus layanan: $e");
    }
  }
}