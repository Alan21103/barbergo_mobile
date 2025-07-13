import 'dart:convert';

import 'package:barbergo_mobile/data/model/request/auth/login_request_model.dart';
import 'package:barbergo_mobile/data/model/request/auth/register_request_model.dart';
import 'package:barbergo_mobile/data/model/response/auth/auth_response_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  // Fungsi login Anda
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        'login',
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromMap(jsonResponse);
        if (authResponse.user?.token != null) {
          await secureStorage.write(
            key: "authToken",
            value: authResponse.user!.token!,
          );
          await secureStorage.write(
            key: "userRole",
            value: authResponse.user!.role ?? '',
          );
        }
        return Right(authResponse);
      } else {
        return Left(jsonResponse['message'] ?? 'Login failed');
      }
    } catch (e) {
      return Left("An error occured while logging in: $e");
    }
  }

  // Fungsi register Anda
  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final registerMessage =
            jsonResponse['message'] ?? "Registrasi berhasil";
        return Right(registerMessage);
      } else {
        return Left(jsonResponse['message'] ?? "Registrasi gagal");
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat registrasi.");
    }
  }

  // <<<--- TAMBAHKAN FUNGSI INI
  Future<Either<String, String?>> getToken() async {
    try {
      final token = await secureStorage.read(key: "authToken");
      if (token != null) {
        return Right(token);
      } else {
        return Left("Token tidak ditemukan.");
      }
    } catch (e) {
      return Left("Gagal mengambil token: ${e.toString()}");
    }
  }

  // <<<--- DISARANKAN: TAMBAHKAN FUNGSI UNTUK MENGHAPUS TOKEN SAAT LOGOUT
  Future<Either<String, bool>> deleteToken() async {
    try {
      await secureStorage.delete(key: "authToken");
      await secureStorage.delete(key: "userRole"); // Juga hapus role saat logout
      return const Right(true);
    } catch (e) {
      return Left("Gagal menghapus token: ${e.toString()}");
    }
  }

  // <<<--- DISARANKAN: Tambahkan juga fungsi untuk mendapatkan role
  Future<Either<String, String?>> getUserRole() async {
    try {
      final role = await secureStorage.read(key: "userRole");
      if (role != null) {
        return Right(role);
      } else {
        return Left("User role not found.");
      }
    } catch (e) {
      return Left("Failed to get user role: ${e.toString()}");
    }
  }
}