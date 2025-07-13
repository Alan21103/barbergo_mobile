import 'package:barbergo_mobile/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_profile_response_model.dart';
import 'package:barbergo_mobile/data/repository/profile_pelanggan_repository.dart';
import 'package:bloc/bloc.dart';

part 'profile_pelanggan_event.dart';
part 'profile_pelanggan_state.dart';

class ProfilePelangganBloc extends Bloc<ProfilePelangganEvent, ProfilePelangganState> {
    final ProfilePelangganRepository profilePelangganRepository;
    ProfilePelangganBloc({required this.profilePelangganRepository})
        : super(ProfilePelangganInitial()) {
        on<AddProfilePelangganEvent>(_addProfilePelanggan);
        on<GetProfilePelangganEvent>(_getProfilePelanggan);
    }

    Future<void> _addProfilePelanggan(
        AddProfilePelangganEvent event,
        Emitter<ProfilePelangganState> emit,
    ) async {
        emit(ProfilePelangganLoading());
        final result = await profilePelangganRepository.addProfilePelanggan(
            event.requestModel,
        );
        result.fold(
            (error) => emit(ProfilePelangganAddError(message: error)),
            (profile) {
                emit(ProfilePelangganAdded(profile: profile));
            },
        );
    }

    Future<void> _getProfilePelanggan(
        GetProfilePelangganEvent event,
        Emitter<ProfilePelangganState> emit,
    ) async {
        emit(ProfilePelangganLoading());
        final result = await profilePelangganRepository.getProfilePelanggan();
        result.fold(
            (error) => emit(ProfilePelangganError(message: error)),
            (profile) => emit(ProfilePelangganLoaded(profile: profile)),
        );
    }
}