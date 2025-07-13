// lib/data/model/response/pelanggan/pelanggan_profile_response_model.dart
import 'dart:convert';

class PelangganProfileResponseModel {
  final String message;
  final int statusCode;
  final Data data; // Menggunakan nama kelas 'Data'

  PelangganProfileResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  PelangganProfileResponseModel copyWith({
    String? message,
    int? statusCode,
    Data? data, // Menggunakan nama kelas 'Data'
  }) =>
      PelangganProfileResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory PelangganProfileResponseModel.fromRawJson(String str) =>
      PelangganProfileResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PelangganProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      PelangganProfileResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]), // Menggunakan Data.fromJson
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

// Mengembalikan nama kelas menjadi 'Data'
class Data {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? photo; // Dibuat nullable karena bisa null dari API
  final String? email; // Tambahkan properti email, dibuat nullable

  Data({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.photo, // Tidak lagi required karena nullable
    this.email, // Tidak lagi required karena nullable
  });

  Data copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? photo,
    String? email, // Tambahkan di copyWith
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        photo: photo ?? this.photo,
        email: email ?? this.email, // Tambahkan di copyWith
      );

  factory Data.fromRawJson(String str) =>
      Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"], // Langsung ambil nilai, null handling oleh tipe `String?`
        email: json["email"], // Ambil nilai email dari JSON
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "photo": photo,
        "email": email, // Tambahkan ke toJson
      };
}
