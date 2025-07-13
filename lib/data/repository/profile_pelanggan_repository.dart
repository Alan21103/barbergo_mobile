import 'dart:convert';
import 'package:barbergo_mobile/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class ProfilePelangganRepository {
  final ServiceHttpClient _serviceHttpClient;
  ProfilePelangganRepository(this._serviceHttpClient);

  Future<Either<String, PelangganProfileResponseModel>> addProfilePelanggan(
    PelangganProfileRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "pelanggan/profile",
        requestModel.toJson(),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final profileResponse = PelangganProfileResponseModel.fromJson(jsonResponse);
        return Right(profileResponse);
      } else {
        final errorMessage = json.decode(response.body);
        print('Error Message: $errorMessage');
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Exception caught: $e');
      return Left("An error occurred while adding profile: $e");
    }
  }

  Future<Either<String, PelangganProfileResponseModel>> getProfilePelanggan() async {
    try {
      final response = await _serviceHttpClient.get("pelanggan/profile");

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final profileResponse = PelangganProfileResponseModel.fromJson(jsonResponse);
        return Right(profileResponse);
      } else {
        final errorMessage = json.decode(response.body);
        print('Error Message: $errorMessage');
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('Exception caught: $e');
      return Left("An error occurred while fetching profile: $e");
    }
  }
}
