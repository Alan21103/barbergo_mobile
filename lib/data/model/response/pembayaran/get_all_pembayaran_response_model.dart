import 'dart:convert';
// Import model Datum dari pemesanan response model jika Pemesanan di sini adalah alias untuk Datum
// Jika Pemesanan adalah kelas terpisah, pastikan tidak ada konflik nama dengan Datum di file lain.
// Contoh: import 'package:barbergo_mobile/data/model/request/pemesanan/get_all_pemesanan_response_model.dart' as PemesananModel;
// Dan kemudian gunakan PemesananModel.Datum

// Untuk saat ini, kita asumsikan Pemesanan di sini adalah kelas Pemesanan yang didefinisikan di bawah.

class GetAllPembayaranResponseModel {
  final int? statusCode;
  final String? message;
  final List<PembayaranDatum>? data;

  GetAllPembayaranResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  GetAllPembayaranResponseModel copyWith({
    int? statusCode,
    String? message,
    List<PembayaranDatum>? data,
  }) =>
      GetAllPembayaranResponseModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetAllPembayaranResponseModel.fromJson(String str) => GetAllPembayaranResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllPembayaranResponseModel.fromMap(Map<String, dynamic> json) => GetAllPembayaranResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PembayaranDatum>.from(json["data"]!.map((x) => PembayaranDatum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class PembayaranDatum {
  final int? id;
  final int? pemesananId;
  final double? amount; // Tipe double?
  final String? status;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? via;
  final Pemesanan? pemesanan; // Relasi ke Pemesanan

  PembayaranDatum({
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

  PembayaranDatum copyWith({
    int? id,
    int? pemesananId,
    double? amount, // Tipe double?
    String? status,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? via,
    Pemesanan? pemesanan,
  }) =>
      PembayaranDatum(
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

  factory PembayaranDatum.fromJson(String str) => PembayaranDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PembayaranDatum.fromMap(Map<String, dynamic> json) => PembayaranDatum(
        id: json["id"],
        pemesananId: json["pemesanan_id"],
        // PERBAIKAN: Parsing amount lebih robust
        amount: json["amount"] == null
            ? null
            : (json["amount"] is String
                ? double.tryParse(json["amount"])
                : (json["amount"] as num?)?.toDouble()),
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

// Kelas Pemesanan yang bersarang di PembayaranDatum (ini harus sesuai dengan struktur API Anda)
// Jika Pemesanan ini adalah alias untuk Datum dari get_all_pemesanan_response_model.dart,
// maka Anda harus menghapus definisi kelas ini dan menggunakan alias impor.
// Contoh:
// import 'package:barbergo_mobile/data/model/request/pemesanan/get_all_pemesanan_response_model.dart' as PemesananModel;
// ...
// final PemesananModel.Datum? pemesanan;
// ...
// pemesanan: json["pemesanan"] == null ? null : PemesananModel.Datum.fromMap(json["pemesanan"]),

class Pemesanan {
  final int? id;
  final int? pelangganId;
  final int? barberId;
  final int? adminId;
  final int? serviceId;
  final DateTime? scheduledTime;
  final String? status;
  final String? alamat;
  final double? latitude; // Tipe double?
  final double? longitude; // Tipe double?
  final double? ongkir; // Tipe double?
  final double? totalPrice; // Tipe double?
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // NEW: Tambahkan relasi ke Pelanggan (jika ada di API)
  final PelangganForPemesanan? pelanggan;

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
    this.pelanggan, // NEW
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
    double? latitude, // Tipe double?
    double? longitude, // Tipe double?
    double? ongkir, // Tipe double?
    double? totalPrice, // Tipe double?
    DateTime? createdAt,
    DateTime? updatedAt,
    PelangganForPemesanan? pelanggan, // NEW
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
        pelanggan: pelanggan ?? this.pelanggan, // NEW
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
        // PERBAIKAN: Parsing latitude lebih robust
        latitude: json["latitude"] == null
            ? null
            : (json["latitude"] is String
                ? double.tryParse(json["latitude"])
                : (json["latitude"] as num?)?.toDouble()),
        // PERBAIKAN: Parsing longitude lebih robust
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] is String
                ? double.tryParse(json["longitude"])
                : (json["longitude"] as num?)?.toDouble()),
        // PERBAIKAN: Parsing ongkir lebih robust
        ongkir: json["ongkir"] == null
            ? null
            : (json["ongkir"] is String
                ? double.tryParse(json["ongkir"])
                : (json["ongkir"] as num?)?.toDouble()),
        // PERBAIKAN: Parsing totalPrice lebih robust
        totalPrice: json["total_price"] == null
            ? null
            : (json["total_price"] is String
                ? double.tryParse(json["total_price"])
                : (json["total_price"] as num?)?.toDouble()),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pelanggan: json["pelanggan"] == null ? null : PelangganForPemesanan.fromMap(json["pelanggan"]), // NEW
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
        "pelanggan": pelanggan?.toMap(), // NEW
      };
}

class PelangganForPemesanan {
  final int? id;
  final String? name;
  final String? email; // Jika ada
  final String? phone; // Jika ada
  final String? address; // Jika ada

  PelangganForPemesanan({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  PelangganForPemesanan copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) =>
      PelangganForPemesanan(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
      );

  factory PelangganForPemesanan.fromJson(String str) => PelangganForPemesanan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PelangganForPemesanan.fromMap(Map<String, dynamic> json) => PelangganForPemesanan(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };
}
