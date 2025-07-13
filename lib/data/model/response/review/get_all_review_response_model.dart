import 'dart:convert';

class GetAllReviewResponseModel {
  final int? statusCode;
  final String? message;
  final List<ReviewDatum>? data;

  GetAllReviewResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetAllReviewResponseModel.fromJson(String str) =>
      GetAllReviewResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllReviewResponseModel.fromMap(Map<String, dynamic> json) =>
      GetAllReviewResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ReviewDatum>.from(
                json["data"]!.map((x) => ReviewDatum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class ReviewDatum {
  final int? id;
  final int? pemesananId;
  final int? rating;
  final String? review;
  final String? deskripsi;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  // Relasi yang mungkin ada, pastikan juga memiliki operator == dan hashCode
  final Pemesanan? pemesanan;

  ReviewDatum({
    this.id,
    this.pemesananId,
    this.rating,
    this.review,
    this.deskripsi,
    this.updatedAt,
    this.createdAt,
    this.pemesanan,
  });

  ReviewDatum copyWith({
    int? id,
    int? pemesananId,
    int? rating,
    String? review,
    String? deskripsi,
    DateTime? updatedAt,
    DateTime? createdAt,
    Pemesanan? pemesanan,
  }) =>
      ReviewDatum(
        id: id ?? this.id,
        pemesananId: pemesananId ?? this.pemesananId,
        rating: rating ?? this.rating,
        review: review ?? this.review,
        deskripsi: deskripsi ?? this.deskripsi,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        pemesanan: pemesanan ?? this.pemesanan,
      );

  factory ReviewDatum.fromJson(String str) =>
      ReviewDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReviewDatum.fromMap(Map<String, dynamic> json) => ReviewDatum(
        id: json["id"],
        pemesananId: json["pemesanan_id"],
        rating: json["rating"],
        review: json["review"],
        deskripsi: json["deskripsi"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        pemesanan: json["pemesanan"] == null
            ? null
            : Pemesanan.fromMap(json["pemesanan"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "pemesanan_id": pemesananId,
        "rating": rating,
        "review": review,
        "deskripsi": deskripsi,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "pemesanan": pemesanan?.toMap(),
      };

  // --- Implementasi manual operator == dan hashCode untuk perbandingan nilai ---
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewDatum &&
        other.id == id &&
        other.pemesananId == pemesananId &&
        other.rating == rating &&
        other.review == review &&
        other.deskripsi == deskripsi &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.pemesanan == pemesanan; // Penting: Bandingkan juga relasi
  }

  @override
  int get hashCode =>
      Object.hash(
        id,
        pemesananId,
        rating,
        review,
        deskripsi,
        updatedAt,
        createdAt,
        pemesanan, // Sertakan relasi di hashCode
      );
}

// --- Kelas-kelas model untuk relasi (jika ada di file yang sama) ---
// Pastikan kelas-kelas ini juga mengimplementasikan operator == dan hashCode
// jika mereka akan dibandingkan di dalam ReviewDatum atau di tempat lain.

class Pemesanan {
  final int? id;
  final int? pelangganId;
  final int? barberId;
  final int? adminId;
  final int? serviceId;
  final DateTime? scheduledTime;
  final String? status;
  final String? alamat;
  final String? latitude;
  final String? longitude;
  final String? ongkir;
  final String? totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pelanggan? pelanggan;
  final Barber? barber;
  final Service? service;

  Pemesanan({
    this.id,
    this.pelangganId,
    this.barberId,
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
    this.pelanggan,
    this.barber,
    this.service,
  });

  factory Pemesanan.fromMap(Map<String, dynamic> json) => Pemesanan(
        id: json["id"],
        pelangganId: json["pelanggan_id"],
        barberId: json["barber_id"],
        adminId: json["admin_id"],
        serviceId: json["service_id"],
        scheduledTime: json["scheduled_time"] == null ? null : DateTime.parse(json["scheduled_time"]),
        status: json["status"],
        alamat: json["alamat"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        ongkir: json["ongkir"],
        totalPrice: json["total_price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pelanggan: json["pelanggan"] == null ? null : Pelanggan.fromMap(json["pelanggan"]),
        barber: json["barber"] == null ? null : Barber.fromMap(json["barber"]),
        service: json["service"] == null ? null : Service.fromMap(json["service"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "pelanggan_id": pelangganId,
        "barber_id": barberId,
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
        "pelanggan": pelanggan?.toMap(),
        "barber": barber?.toMap(),
        "service": service?.toMap(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pemesanan &&
        other.id == id &&
        other.pelangganId == pelangganId &&
        other.barberId == barberId &&
        other.adminId == adminId &&
        other.serviceId == serviceId &&
        other.scheduledTime == scheduledTime &&
        other.status == status &&
        other.alamat == alamat &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.ongkir == ongkir &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.pelanggan == pelanggan &&
        other.barber == barber &&
        other.service == service;
  }

  @override
  int get hashCode => Object.hash(
        id,
        pelangganId,
        barberId,
        adminId,
        serviceId,
        scheduledTime,
        status,
        alamat,
        latitude,
        longitude,
        ongkir,
        totalPrice,
        createdAt,
        updatedAt,
        pelanggan,
        barber,
        service,
      );
}

class Pelanggan {
  final int? id;
  final int? userId;
  final String? name;
  final String? address;
  final String? phone;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pelanggan({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.phone,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory Pelanggan.fromMap(Map<String, dynamic> json) => Pelanggan(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "address": address,
        "phone": phone,
        "photo": photo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pelanggan &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.address == address &&
        other.phone == phone &&
        other.photo == photo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        name,
        address,
        phone,
        photo,
        createdAt,
        updatedAt,
      );
}

class Barber {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? roleId;

  Barber({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.roleId,
  });

  factory Barber.fromMap(Map<String, dynamic> json) => Barber(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        roleId: json["role_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role_id": roleId,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Barber &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.roleId == roleId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        emailVerifiedAt,
        createdAt,
        updatedAt,
        roleId,
      );
}

class Service {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
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

  factory Service.fromMap(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Service &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        price,
        createdAt,
        updatedAt,
      );
}
