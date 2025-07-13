import 'package:barbergo_mobile/data/model/response/review/get_all_review_response_model.dart';
import 'package:barbergo_mobile/data/model/response/review/review_response_model.dart'; // Import for Data model

abstract class ReviewState {
  const ReviewState();
}

/// State awal untuk Review Bloc.
class ReviewInitialState extends ReviewState {}

/// State saat ulasan sedang dimuat.
class ReviewsLoadingState extends ReviewState {}

/// State saat ulasan berhasil dimuat.
class ReviewsLoadedState extends ReviewState {
  final List<ReviewDatum> reviews;
  const ReviewsLoadedState({required this.reviews});
}

/// State saat terjadi kesalahan dalam memuat ulasan.
class ReviewsErrorState extends ReviewState {
  final String error;
  const ReviewsErrorState({required this.error});
}

/// State saat operasi CUD (Create, Update, Delete) sedang berlangsung.
class ReviewCudLoadingState extends ReviewState {}

/// State saat ulasan berhasil dibuat.
class ReviewCreatedState extends ReviewState {
  final Data review; // Assuming 'Data' is the successful response model for a single review
  const ReviewCreatedState({required this.review});
}

/// State saat ulasan berhasil diperbarui.
class ReviewUpdatedState extends ReviewState {
  final Data review; // Assuming 'Data' is the successful response model for a single review
  const ReviewUpdatedState({required this.review});
}

/// State saat ulasan berhasil dihapus.
class ReviewDeletedState extends ReviewState {
  final String message;
  const ReviewDeletedState({required this.message});
}

/// State saat terjadi kesalahan dalam operasi CUD (Create, Update, Delete).
class ReviewCudErrorState extends ReviewState {
  final String error;
  const ReviewCudErrorState({required this.error});
}