part of 'profile_pelanggan_bloc.dart';

sealed class ProfilePelangganState {}

final class ProfilePelangganInitial extends ProfilePelangganState {}

final class ProfilePelangganLoading extends ProfilePelangganState {}

final class ProfilePelangganLoaded extends ProfilePelangganState {
    final PelangganProfileResponseModel profile;

    ProfilePelangganLoaded({required this.profile});
}

final class ProfilePelangganError extends ProfilePelangganState {
    final String message;

    ProfilePelangganError({required this.message});
}

final class ProfilePelangganAdded extends ProfilePelangganState {
    final PelangganProfileResponseModel profile;

    ProfilePelangganAdded({required this.profile});
}

final class ProfilePelangganAddError extends ProfilePelangganState {
    final String message;

    ProfilePelangganAddError({required this.message});
}