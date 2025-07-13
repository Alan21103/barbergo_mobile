import 'package:barbergo_mobile/data/model/request/admin/admin_profile_request_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/admin_profile_response_model.dart';
import 'package:barbergo_mobile/data/repository/profile_admin_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'profile_admin_event.dart';
part 'profile_admin_state.dart';

class ProfileAdminBloc extends Bloc<ProfileAdminEvent, ProfileAdminState> {
    final ProfileAdminRepository profileAdminRepository;
    ProfileAdminBloc({required this.profileAdminRepository})
        : super(ProfileAdminInitial()) {
        on<AddProfileAdminEvent>(_addProfileAdmin);
        on<GetProfileAdminEvent>(_getProfileAdmin);
    }

    Future<void> _addProfileAdmin(
        AddProfileAdminEvent event,
        Emitter<ProfileAdminState> emit,
    ) async {
        emit(ProfileAdminLoading());
        final result = await profileAdminRepository.addProfile(
            event.requestModel,
        );
        result.fold(
            (error) => emit(ProfileAdminAddError(message: error)),
            (profile) {
                emit(ProfileAdminAdded(profile: profile));
            },
        );
    }

    Future<void> _getProfileAdmin(
        GetProfileAdminEvent event,
        Emitter<ProfileAdminState> emit,
    ) async {
        emit(ProfileAdminLoading());
        final result = await profileAdminRepository.getProfile();
        result.fold(
            (error) => emit(ProfileAdminError(message: error)),
            (profile) => emit(ProfileAdminLoaded(profile: profile)),
        );
    }
}