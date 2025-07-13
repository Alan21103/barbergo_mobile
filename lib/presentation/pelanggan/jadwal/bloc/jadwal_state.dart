part of 'jadwal_bloc.dart';

@immutable
abstract class JadwalState {
  const JadwalState();
}

class JadwalInitial extends JadwalState {}

// States for loading operations (both all schedules and my schedules)
class JadwalLoadingState extends JadwalState {}

class JadwalLoadedState extends JadwalState {
  final List<JadwalDatum> schedules;

  const JadwalLoadedState(this.schedules);
}

class JadwalErrorState extends JadwalState {
  final String error;

  const JadwalErrorState(this.error);
}

// States for CUD (Create, Update, Delete) operations
class JadwalCreatingState extends JadwalState {}
class JadwalUpdatingState extends JadwalState {}
class JadwalDeletingState extends JadwalState {}

class JadwalActionSuccess extends JadwalState {
  final String message;
  const JadwalActionSuccess(this.message);
}

class JadwalActionFailure extends JadwalState {
  final String error;
  const JadwalActionFailure(this.error);
}
