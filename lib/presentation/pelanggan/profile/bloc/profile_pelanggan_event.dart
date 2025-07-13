part of 'profile_pelanggan_bloc.dart';

sealed class ProfilePelangganEvent {}

class AddProfilePelangganEvent extends ProfilePelangganEvent {
    final PelangganProfileRequestModel requestModel;

    AddProfilePelangganEvent({required this.requestModel});
}

class GetProfilePelangganEvent extends ProfilePelangganEvent {}