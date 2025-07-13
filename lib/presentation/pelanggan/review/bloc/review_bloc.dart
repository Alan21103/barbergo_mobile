import 'package:barbergo_mobile/data/repository/review_repository.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_event.dart';
import 'package:barbergo_mobile/presentation/pelanggan/review/bloc/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer'; // Import for logging

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(ReviewInitialState()) {
    on<LoadReviewsEvent>((event, emit) async {
      log('ReviewBloc: Handling LoadReviewsEvent...');
      emit(ReviewsLoadingState());
      try {
        final reviews = await reviewRepository.getAllReviews();
        emit(ReviewsLoadedState(reviews: reviews));
        log('ReviewBloc: Successfully loaded ${reviews.length} reviews.');
      } catch (e) {
        emit(ReviewsErrorState(error: e.toString()));
        log('ReviewBloc: Error loading reviews: $e');
      }
    });

    on<CreateReviewEvent>((event, emit) async {
      log('ReviewBloc: Handling CreateReviewEvent...');
      emit(ReviewCudLoadingState());
      try {
        final result = await reviewRepository.createReview(event.pemesananId, event.requestModel);
        result.fold(
          (l) {
            emit(ReviewCudErrorState(error: l));
            log('ReviewBloc: Error creating review: $l');
          },
          (r) {
            emit(ReviewCreatedState(review: r));
            log('ReviewBloc: Successfully created review with ID: ${r.id}');
            // Optionally, reload all reviews after creation
            add(LoadReviewsEvent());
          },
        );
      } catch (e) {
        emit(ReviewCudErrorState(error: e.toString()));
        log('ReviewBloc: Unexpected error creating review: $e');
      }
    });

    on<UpdateReviewEvent>((event, emit) async {
      log('ReviewBloc: Handling UpdateReviewEvent...');
      emit(ReviewCudLoadingState());
      try {
        final result = await reviewRepository.updateReview(event.reviewId, event.requestModel);
        result.fold(
          (l) {
            emit(ReviewCudErrorState(error: l));
            log('ReviewBloc: Error updating review: $l');
          },
          (r) {
            emit(ReviewUpdatedState(review: r));
            log('ReviewBloc: Successfully updated review with ID: ${r.id}');
            // Optionally, reload all reviews after update
            add(LoadReviewsEvent());
          },
        );
      } catch (e) {
        emit(ReviewCudErrorState(error: e.toString()));
        log('ReviewBloc: Unexpected error updating review: $e');
      }
    });

    on<DeleteReviewEvent>((event, emit) async {
      log('ReviewBloc: Handling DeleteReviewEvent...');
      emit(ReviewCudLoadingState());
      try {
        final result = await reviewRepository.deleteReview(event.reviewId);
        result.fold(
          (l) {
            emit(ReviewCudErrorState(error: l));
            log('ReviewBloc: Error deleting review: $l');
          },
          (r) {
            emit(ReviewDeletedState(message: r));
            log('ReviewBloc: Successfully deleted review: $r');
            // Optionally, reload all reviews after deletion
            add(LoadReviewsEvent());
          },
        );
      } catch (e) {
        emit(ReviewCudErrorState(error: e.toString()));
        log('ReviewBloc: Unexpected error deleting review: $e');
      }
    });
  }
}