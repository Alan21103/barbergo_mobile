part of 'profile_admin_bloc.dart';

sealed class ProfileAdminState {}

final class ProfileAdminInitial extends ProfileAdminState {}

final class ProfileAdminLoading extends ProfileAdminState {}

final class ProfileAdminLoaded extends ProfileAdminState {
    final AdminProfileResponseModel profile;

    ProfileAdminLoaded({required this.profile});
}

final class ProfileAdminError extends ProfileAdminState {
    final String message;

    ProfileAdminError({required this.message});
}

final class ProfileAdminAdded extends ProfileAdminState {
    final AdminProfileResponseModel profile;

    ProfileAdminAdded({required this.profile});
}

final class ProfileAdminAddError extends ProfileAdminState {
    final String message;

    ProfileAdminAddError({required this.message});
}