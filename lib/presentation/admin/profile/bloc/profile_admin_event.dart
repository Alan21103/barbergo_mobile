part of 'profile_admin_bloc.dart';

sealed class ProfileAdminEvent {}

class AddProfileAdminEvent extends ProfileAdminEvent {
    final AdminProfileRequestModel requestModel;

    AddProfileAdminEvent({required this.requestModel});
}

class GetProfileAdminEvent extends ProfileAdminEvent {}