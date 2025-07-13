import 'package:flutter/material.dart';


@immutable
sealed class PortofoliosEvent {}

/// Event untuk memuat semua portofolio dari repository.
class GetPortofoliosEvent extends PortofoliosEvent {}

/// Event untuk memuat portofolio milik barber yang sedang login.
class GetMyPortofoliosEvent extends PortofoliosEvent {}

/// Event untuk membuat portofolio baru.
class CreatePortofoliosEvent extends PortofoliosEvent {
  final String? image; // String (Base64 atau URL) untuk gambar
  final String? description;

  CreatePortofoliosEvent({
    this.image,
    this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatePortofoliosEvent &&
        other.image == image &&
        other.description == description;
  }

  @override
  int get hashCode => image.hashCode ^ description.hashCode;
}

/// Event untuk memperbarui portofolio yang sudah ada.
class UpdatePortofoliosEvent extends PortofoliosEvent {
  final int id;
  final String? image; // String (Base64 atau URL) untuk gambar (opsional)
  final String? description; // Deskripsi baru (opsional)

  UpdatePortofoliosEvent({
    required this.id,
    this.image,
    this.description,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdatePortofoliosEvent &&
        other.id == id &&
        other.image == image &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ image.hashCode ^ description.hashCode;
}

/// Event untuk menghapus portofolio.
class DeletePortofoliosEvent extends PortofoliosEvent {
  final int id;

  DeletePortofoliosEvent({required this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeletePortofoliosEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
