import 'package:barbergo_mobile/data/model/request/review/review_request_model.dart';

abstract class ReviewEvent {
  const ReviewEvent();
}

/// Event untuk memuat semua ulasan.
class LoadReviewsEvent extends ReviewEvent {}

/// Event untuk membuat ulasan baru.
class CreateReviewEvent extends ReviewEvent {
  final int pemesananId;
  final ReviewRequestModel requestModel;

  const CreateReviewEvent({required this.pemesananId, required this.requestModel});
}

/// Event untuk memperbarui ulasan yang sudah ada.
class UpdateReviewEvent extends ReviewEvent {
  final int reviewId;
  final ReviewRequestModel requestModel;

  const UpdateReviewEvent({required this.reviewId, required this.requestModel});
}

/// Event untuk menghapus ulasan.
class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;

  const DeleteReviewEvent({required this.reviewId});
}