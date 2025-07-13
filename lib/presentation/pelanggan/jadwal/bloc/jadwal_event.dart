part of 'jadwal_bloc.dart';

@immutable
abstract class JadwalEvent {
  const JadwalEvent();
}

// Event untuk memuat semua jadwal (misalnya, untuk admin melihat semua)
class LoadAllJadwalEvent extends JadwalEvent {
  const LoadAllJadwalEvent();
}

// Event untuk memuat jadwal milik barber yang sedang login
class LoadMyJadwalEvent extends JadwalEvent {
  const LoadMyJadwalEvent();
}

// Event untuk membuat jadwal baru untuk barber yang sedang login
class CreateMyJadwalEvent extends JadwalEvent {
  final String hari;
  final String tersediaDari;
  final String tersediaHingga;

  const CreateMyJadwalEvent({
    required this.hari,
    required this.tersediaDari,
    required this.tersediaHingga,
  });
}

// Event untuk memperbarui jadwal yang sudah ada milik barber yang sedang login
class UpdateMyJadwalEvent extends JadwalEvent {
  final int id;
  final String hari;
  final String tersediaDari;
  final String tersediaHingga;

  const UpdateMyJadwalEvent({
    required this.id,
    required this.hari,
    required this.tersediaDari,
    required this.tersediaHingga,
  });
}

// Event untuk menghapus jadwal milik barber yang sedang login
class DeleteMyJadwalEvent extends JadwalEvent {
  final int id;

  const DeleteMyJadwalEvent({required this.id});
}
