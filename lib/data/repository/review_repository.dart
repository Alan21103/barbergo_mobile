// lib/data/repository/review/review_repository.dart

import 'dart:convert';

import 'package:barbergo_mobile/data/model/request/review/review_request_model.dart';
import 'package:barbergo_mobile/data/model/response/review/get_all_review_response_model.dart';
import 'dart:developer';

import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../model/response/review/review_response_model.dart';


class ReviewRepository {
  final ServiceHttpClient _serviceHttpClient; // Mengganti httpClient menjadi _serviceHttpClient

  // Perbaikan: Gunakan satu parameter posisi untuk menginisialisasi _serviceHttpClient
  ReviewRepository(this._serviceHttpClient); // Mengganti httpClient menjadi _serviceHttpClient

  /// Mengambil semua ulasan dari API.
  /// Melemparkan Exception jika gagal memuat ulasan.
  Future<List<ReviewDatum>> getAllReviews() async {
    log('ReviewRepository: Attempting to fetch all reviews...');
    try {
      final response = await _serviceHttpClient.getWithToken('reviews'); // Menggunakan _serviceHttpClient
      
      log('ReviewRepository: Received response for reviews. Status Code: ${response.statusCode}');
      log('ReviewRepository: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final GetAllReviewResponseModel reviewResponse =
            GetAllReviewResponseModel.fromJson(response.body);
        log('ReviewRepository: Successfully parsed ${reviewResponse.data?.length ?? 0} reviews.');
        return reviewResponse.data ?? [];
      } else if (response.statusCode == 404) {
        // Handle case where no reviews are found (API returns 404 with empty data)
        log('ReviewRepository: No reviews found (Status 404). Returning empty list.');
        return [];
      } else {
        throw Exception('Failed to load reviews: Status Code ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      log('ReviewRepository: Error fetching reviews: $e');
      throw Exception('Failed to load reviews: $e');
    }
  }

   Future<Either<String, Data>> createReview(
      int pemesananId, ReviewRequestModel requestModel) async {
    http.Response? response;
    final String endpoint = 'pelanggan/pemesanan/$pemesananId/reviews';

    try {
      log('ReviewRepository: Attempting to create review for pemesanan ID: $pemesananId');
      log('ReviewRepository: Request Body: ${requestModel.toMap()}');

      response =
          await _serviceHttpClient.postWithToken(endpoint, requestModel.toMap());

      log('ReviewRepository: Received response for create review. Status Code: ${response.statusCode}');
      log('ReviewRepository: Response Body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat membuat ulasan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 201) {
        final ReviewResponseModel reviewResponse =
            ReviewResponseModel.fromJson(response.body);
        if (reviewResponse.data != null) {
          log('ReviewRepository: Create review successful. Review ID: ${reviewResponse.data!.id}');
          return Right(reviewResponse.data!);
        } else {
          return Left(
              reviewResponse.message ?? "Gagal membuat ulasan: Data respons kosong.");
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        return Left(
            "Gagal membuat ulasan: Status Code ${response.statusCode}, Pesan: $errorMessage");
      }
    } on FormatException catch (e) {
      log('ReviewRepository: FormatException creating review: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}');
      return Left(
          "Terjadi kesalahan format data dari server saat membuat ulasan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log('ReviewRepository: Error creating review: $e', error: e);
      return Left("Terjadi kesalahan tak terduga saat membuat ulasan: $e");
    }
  }

  /// Memperbarui ulasan yang sudah ada.
  /// Membutuhkan [reviewId] dan [requestModel] yang berisi rating, review, deskripsi.
  /// Mengembalikan [Either<String, Data>] (objek ulasan yang diperbarui) jika berhasil atau pesan error jika gagal.
  Future<Either<String, Data>> updateReview(
      int reviewId, ReviewRequestModel requestModel) async {
    http.Response? response;
    final String endpoint = 'pelanggan/reviews/$reviewId';

    try {
      log('ReviewRepository: Attempting to update review ID: $reviewId');
      log('ReviewRepository: Request Body: ${requestModel.toMap()}');

      response =
          await _serviceHttpClient.putWithToken(endpoint, requestModel.toMap());

      log('ReviewRepository: Received response for update review. Status Code: ${response.statusCode}');
      log('ReviewRepository: Response Body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat memperbarui ulasan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final ReviewResponseModel reviewResponse =
            ReviewResponseModel.fromJson(response.body);
        if (reviewResponse.data != null) {
          log('ReviewRepository: Update review successful. Review ID: ${reviewResponse.data!.id}');
          return Right(reviewResponse.data!);
        } else {
          return Left(
              reviewResponse.message ?? "Gagal memperbarui ulasan: Data respons kosong.");
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        return Left(
            "Gagal memperbarui ulasan: Status Code ${response.statusCode}, Pesan: $errorMessage");
      }
    } on FormatException catch (e) {
      log('ReviewRepository: FormatException updating review: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}');
      return Left(
          "Terjadi kesalahan format data dari server saat memperbarui ulasan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log('ReviewRepository: Error updating review: $e', error: e);
      return Left("Terjadi kesalahan tak terduga saat memperbarui ulasan: $e");
    }
  }

  /// Menghapus ulasan.
  /// Membutuhkan [reviewId] dari ulasan yang akan dihapus.
  /// Mengembalikan [Either<String, String>] (pesan sukses) jika berhasil atau pesan error jika gagal.
  Future<Either<String, String>> deleteReview(int reviewId) async {
    http.Response? response;
    final String endpoint = 'pelanggan/reviews/$reviewId';

    try {
      log('ReviewRepository: Attempting to delete review ID: $reviewId');

      response = await _serviceHttpClient.deleteWithToken(endpoint);

      log('ReviewRepository: Received response for delete review. Status Code: ${response.statusCode}');
      log('ReviewRepository: Response Body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        return Left(
            "Server mengembalikan respons non-JSON saat menghapus ulasan. Diharapkan application/json, tetapi mendapatkan: $contentType. Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final String message = jsonResponse['message'] ?? 'Ulasan berhasil dihapus';
        log('ReviewRepository: Delete review successful: $message');
        return Right(message);
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        return Left(
            "Gagal menghapus ulasan: Status Code ${response.statusCode}, Pesan: $errorMessage");
      }
    } on FormatException catch (e) {
      log('ReviewRepository: FormatException deleting review: $e. Body: ${response?.body ?? 'Response body tidak tersedia'}');
      return Left(
          "Terjadi kesalahan format data dari server saat menghapus ulasan. Respons bukan JSON yang valid. Detail: $e");
    } catch (e) {
      log('ReviewRepository: Error deleting review: $e', error: e);
      return Left("Terjadi kesalahan tak terduga saat menghapus ulasan: $e");
    }
  }
}
