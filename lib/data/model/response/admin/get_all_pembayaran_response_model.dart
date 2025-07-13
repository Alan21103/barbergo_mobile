import 'dart:convert';

class GetAllAdminPembayaranResponseModel {
    final int? statusCode;
    final String? message;
    final List<PembayaranData>? data;

    GetAllAdminPembayaranResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    GetAllAdminPembayaranResponseModel copyWith({
        int? statusCode,
        String? message,
        List<PembayaranData>? data,
    }) => 
        GetAllAdminPembayaranResponseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetAllAdminPembayaranResponseModel.fromJson(String str) => GetAllAdminPembayaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllAdminPembayaranResponseModel.fromMap(Map<String, dynamic> json) => GetAllAdminPembayaranResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PembayaranData>.from(json["data"]!.map((x) => PembayaranData.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class PembayaranData {
    final int? id;
    final int? pemesananId;
    final String? amount;
    final String? status;
    final DateTime? paidAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? via;
    final Pemesanan? pemesanan;

    PembayaranData({
        this.id,
        this.pemesananId,
        this.amount,
        this.status,
        this.paidAt,
        this.createdAt,
        this.updatedAt,
        this.via,
        this.pemesanan,
    });

    PembayaranData copyWith({
        int? id,
        int? pemesananId,
        String? amount,
        String? status,
        DateTime? paidAt,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? via,
        Pemesanan? pemesanan,
    }) => 
        PembayaranData(
            id: id ?? this.id,
            pemesananId: pemesananId ?? this.pemesananId,
            amount: amount ?? this.amount,
            status: status ?? this.status,
            paidAt: paidAt ?? this.paidAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            via: via ?? this.via,
            pemesanan: pemesanan ?? this.pemesanan,
        );

    factory PembayaranData.fromJson(String str) => PembayaranData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PembayaranData.fromMap(Map<String, dynamic> json) => PembayaranData(
        id: json["id"],
        pemesananId: json["pemesanan_id"],
        amount: json["amount"],
        status: json["status"],
        paidAt: json["paid_at"] == null ? null : DateTime.parse(json["paid_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        via: json["via"],
        pemesanan: json["pemesanan"] == null ? null : Pemesanan.fromMap(json["pemesanan"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "pemesanan_id": pemesananId,
        "amount": amount,
        "status": status,
        "paid_at": paidAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "via": via,
        "pemesanan": pemesanan?.toMap(),
    };
}

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
    });

    Pemesanan copyWith({
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
    }) => 
        Pemesanan(
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
        );

    factory Pemesanan.fromJson(String str) => Pemesanan.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

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
    };
}
