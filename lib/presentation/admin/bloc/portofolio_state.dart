import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:barbergo_mobile/data/model/response/portofolios/get_all_portofolios_response_model.dart';



@immutable
sealed class PortofoliosState {}

/// State awal Bloc, sebelum operasi apapun dimulai.
final class PortofoliosInitial extends PortofoliosState {}

/// State saat data sedang dimuat dari repository.
final class PortofoliosLoading extends PortofoliosState {}

/// State ketika data portofolio berhasil dimuat.
/// Berisi daftar [PortofolioDatum] yang diterima.
final class PortofoliosLoaded extends PortofoliosState {
  final List<PortofolioDatum> portfolios;

  PortofoliosLoaded({required this.portfolios}); // Menggunakan named parameter

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // Menggunakan listEquals untuk membandingkan list secara mendalam
    return other is PortofoliosLoaded && listEquals(other.portfolios, portfolios);
  }

  @override
  int get hashCode => portfolios.hashCode;
}

/// State ketika terjadi kesalahan saat memuat data portofolio.
/// Berisi pesan kesalahan [message].
final class PortofoliosError extends PortofoliosState {
  final String message;

  PortofoliosError({required this.message}); // Menggunakan named parameter

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PortofoliosError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// --- States untuk operasi CUD (Create, Update, Delete) ---

/// State saat operasi pembuatan portofolio sedang berlangsung.
final class PortofoliosCreating extends PortofoliosState {}

/// State saat operasi pembaruan portofolio sedang berlangsung.
final class PortofoliosUpdating extends PortofoliosState {}

/// State saat operasi penghapusan portofolio sedang berlangsung.
final class PortofoliosDeleting extends PortofoliosState {}

/// State ketika operasi CUD berhasil.
/// Berisi pesan sukses [message].
final class PortofoliosActionSuccess extends PortofoliosState {
  final String message;

  PortofoliosActionSuccess({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PortofoliosActionSuccess && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// State ketika operasi CUD gagal.
/// Berisi pesan kesalahan [error].
final class PortofoliosActionFailure extends PortofoliosState {
  final String error;

  PortofoliosActionFailure({required this.error});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PortofoliosActionFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
