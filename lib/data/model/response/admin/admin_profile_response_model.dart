import 'dart:convert';

class AdminProfileResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  AdminProfileResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  AdminProfileResponseModel copyWith({
    String? message,
    int? statusCode,
    Data? data,
  }) =>
      AdminProfileResponseModel(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory AdminProfileResponseModel.fromJson(String str) =>
      AdminProfileResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminProfileResponseModel.fromMap(Map<String, dynamic> json) =>
      AdminProfileResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
      };

  // Fungsi untuk mengonversi AdminProfileResponseModel ke Data
  Data toData() {
    return Data(
      id: data?.id,
      name: data?.name,
      alamat: data?.alamat,
      latitude: data?.latitude,
      longitude: data?.longitude,
    );
  }
}

class Data {
  final int? id;
  final String? name;
  final String? alamat;
  final double? latitude;
  final double? longitude;

  Data({
    this.id,
    this.name,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  Data copyWith({
    int? id,
    String? name,
    String? alamat,
    double? latitude,
    double? longitude,
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        alamat: alamat ?? this.alamat,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) {
    double? parseToDouble(dynamic value) {
      if (value is String) {
        return double.tryParse(value);  // Menggunakan tryParse untuk mengonversi string ke double
      } else if (value is double) {
        return value;
      }
      return null;
    }

    return Data(
      id: json["id"],
      name: json["name"],
      alamat: json["alamat"],
      latitude: parseToDouble(json["latitude"]),
      longitude: parseToDouble(json["longitude"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
      };
}
