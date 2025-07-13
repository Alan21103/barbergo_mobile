import 'dart:convert';

// Anda mungkin perlu mengimpor model-model nested seperti Pelanggan, Barber, Service
// Jika mereka didefinisikan di file terpisah.
// Contoh:
// import 'package:barbergo_mobile/data/model/response/pelanggan/pelanggan_model.dart';
// import 'package:barbergo_mobile/data/model/response/barber/barber_model.dart';
// import 'package:barbergo_mobile/data/model/response/service/service_model.dart';


class GetAllAdminPemesananResponseModel {
    final int? statusCode; // Ditambahkan kembali
    final String? message;
    final List<PemesananData>? data;

    GetAllAdminPemesananResponseModel({
        this.statusCode, // Ditambahkan kembali
        this.message,
        this.data,
    });

    GetAllAdminPemesananResponseModel copyWith({
        int? statusCode, // Ditambahkan kembali
        String? message,
        List<PemesananData>? data,
    }) =>
        GetAllAdminPemesananResponseModel(
            statusCode: statusCode ?? this.statusCode, // Ditambahkan kembali
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetAllAdminPemesananResponseModel.fromJson(String str) => GetAllAdminPemesananResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllAdminPemesananResponseModel.fromMap(Map<String, dynamic> json) => GetAllAdminPemesananResponseModel(
        statusCode: json["status_code"], // Parsing status_code
        message: json["message"],
        data: json["data"] == null ? [] : List<PemesananData>.from(json["data"]!.map((x) => PemesananData.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode, // Menambahkan status_code ke map
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class PemesananData {
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

    PemesananData({
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

    PemesananData copyWith({
        int? id,
        int? pelangganId,
        int? barberId,
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
        Pelanggan? pelanggan,
        Barber? barber,
        Service? service,
    }) =>
        PemesananData(
            id: id ?? this.id,
            pelangganId: pelangganId ?? this.pelangganId,
            barberId: barberId ?? this.barberId,
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
            pelanggan: pelanggan ?? this.pelanggan,
            barber: barber ?? this.barber,
            service: service ?? this.service,
        );

    factory PemesananData.fromJson(String str) => PemesananData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PemesananData.fromMap(Map<String, dynamic> json) => PemesananData(
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

    Barber copyWith({
        int? id,
        String? name,
        String? email,
        dynamic emailVerifiedAt,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? roleId,
    }) =>
        Barber(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            roleId: roleId ?? this.roleId,
        );

    factory Barber.fromJson(String str) => Barber.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

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

    Pelanggan copyWith({
        int? id,
        int? userId,
        String? name,
        String? address,
        String? phone,
        String? photo,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) =>
        Pelanggan(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            name: name ?? this.name,
            address: address ?? this.address,
            phone: phone ?? this.phone,
            photo: photo ?? this.photo,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Pelanggan.fromJson(String str) => Pelanggan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

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

    factory Service.fromJson(String str) => Service.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

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
}
