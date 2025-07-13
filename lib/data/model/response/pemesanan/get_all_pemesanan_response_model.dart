import 'dart:convert';

// Fungsi helper untuk konversi dari JSON string ke model
GetAllPemesananResponseModel getAllPemesananResponseModelFromJson(String str) =>
    GetAllPemesananResponseModel.fromMap(json.decode(str));

// Fungsi helper untuk konversi dari model ke JSON string
String getAllPemesananResponseModelToJson(GetAllPemesananResponseModel data) =>
    json.encode(data.toMap());

class GetAllPemesananResponseModel {
  final int? statusCode;
  final String? message;
  final List<Datum>? data; // Menggunakan Datum sebagai tipe data list

  GetAllPemesananResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  GetAllPemesananResponseModel copyWith({
    int? statusCode,
    String? message,
    List<Datum>? data,
  }) =>
      GetAllPemesananResponseModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  // Factory constructor untuk membuat instance dari JSON string
  factory GetAllPemesananResponseModel.fromJson(String str) =>
      GetAllPemesananResponseModel.fromMap(json.decode(str));

  // Mengubah ke JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory GetAllPemesananResponseModel.fromMap(Map<String, dynamic> json) =>
      GetAllPemesananResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  // Mengubah ke Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  final int? id;
  final int? pelangganId;
  final Pelanggan? pelanggan; // Hubungan ke model Pelanggan
  final int? barberId;
  final User? barber; // Hubungan ke model User (untuk barber)
  final int? adminId;
  final int? serviceId;
  final DateTime? scheduledTime;
  final String? status;
  final String? alamat;
  final String? latitude; // Disesuaikan menjadi String
  final String? longitude; // Disesuaikan menjadi String
  final String? ongkir; // Disesuaikan menjadi String
  final String? totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;

  Datum({
    this.id,
    this.pelangganId,
    this.pelanggan,
    this.barberId,
    this.barber,
    this.adminId,
    this.serviceId,
    this.scheduledTime,
    this.status,
    this.alamat,
    this.latitude,
    this.longitude,
    this.ongkir,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  Datum copyWith({
    int? id,
    int? pelangganId,
    Pelanggan? pelanggan,
    int? barberId,
    User? barber,
    int? adminId,
    int? serviceId,
    DateTime? scheduledTime,
    String? status,
    String? alamat,
    String? latitude,
    String? longitude,
    String? ongkir,
    String? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    Service? service,
  }) =>
      Datum(
        id: id ?? this.id,
        pelangganId: pelangganId ?? this.pelangganId,
        pelanggan: pelanggan ?? this.pelanggan,
        barberId: barberId ?? this.barberId,
        barber: barber ?? this.barber,
        adminId: adminId ?? this.adminId,
        serviceId: serviceId ?? this.serviceId,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        status: status ?? this.status,
        alamat: alamat ?? this.alamat,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        ongkir: ongkir ?? this.ongkir,
        totalPrice: totalPrice ?? this.totalPrice,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        service: service ?? this.service,
      );

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        pelangganId: json["pelanggan_id"],
        // Pastikan Anda memanggil fromMap/fromJson yang benar untuk Pelanggan
        pelanggan: json["pelanggan"] == null
            ? null
            : Pelanggan.fromJson(json["pelanggan"]),
        barberId: json["barber_id"],
        // Pastikan Anda memanggil fromMap/fromJson yang benar untuk User
        barber: json["barber"] == null ? null : User.fromJson(json["barber"]),
        adminId: json["admin_id"],
        serviceId: json["service_id"],
        scheduledTime: json["scheduled_time"] == null
            ? null
            : DateTime.parse(json["scheduled_time"]),
        status: json["status"],
        alamat: json["alamat"],
        latitude: json["latitude"]?.toString(), // Handle sebagai String
        longitude: json["longitude"]?.toString(), // Handle sebagai String
        ongkir: json["ongkir"]?.toString(), // Handle sebagai String
        totalPrice: json["total_price"]?.toString(), // Handle sebagai String
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        // Pastikan Anda memanggil fromMap/fromJson yang benar untuk Service
        service: json["service"] == null ? null : Service.fromMap(json["service"]),
      );

  // Mengubah ke Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "id": id,
        "pelanggan_id": pelangganId,
        "pelanggan": pelanggan?.toMap(),
        "barber_id": barberId,
        "barber": barber?.toMap(),
        "admin_id": adminId,
        "service_id": serviceId,
        "scheduled_time": scheduledTime?.toIso8601String(),
        "status": status,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
        "ongkir": ongkir,
        "total_price": totalPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service": service?.toMap(),
      };
}

class Pelanggan {
  final int? id; // Ubah ke nullable
  final String? name;
  final String? address;
  final String? phone;
  final int? userId;
  final String? photo;

  Pelanggan({
    this.id, // Ubah ke nullable
    this.name,
    this.address,
    this.phone,
    this.userId,
    this.photo,
  });

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory Pelanggan.fromJson(Map<String, dynamic> json) => Pelanggan(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        userId: json["user_id"],
        photo: json["photo"],
      );

  // Mengubah ke Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "user_id": userId,
        "photo": photo,
      };
}

class User {
  final int? id; // Ubah ke nullable
  final String? name;
  final String? email;
  final String? emailVerifiedAt; // Tetap String atau ubah ke DateTime jika Anda parse
  final int? roleId;

  User({
    this.id, // Ubah ke nullable
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.roleId,
  });

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        roleId: json["role_id"],
      );

  // Mengubah ke Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "role_id": roleId,
      };
}

class Service {
  final int? id;
  final String? name;
  final String? description;
  final String? price; // Disesuaikan menjadi String
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Service({
    this.id,
    this.name,
    this.description,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  Service copyWith({
    int? id,
    String? name,
    String? description,
    String? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Service(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  // Factory constructor untuk membuat instance dari JSON string
  factory Service.fromJson(String str) => Service.fromMap(json.decode(str));

  // Mengubah ke JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory Service.fromMap(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toString(), // Handle sebagai String
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  // Mengubah ke Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}