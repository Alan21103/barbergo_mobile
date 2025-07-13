import 'dart:convert';

class ReviewResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    ReviewResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    ReviewResponseModel copyWith({
        int? statusCode,
        String? message,
        Data? data,
    }) => 
        ReviewResponseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ReviewResponseModel.fromJson(String str) => ReviewResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReviewResponseModel.fromMap(Map<String, dynamic> json) => ReviewResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? pemesananId;
    final int? rating;
    final String? review;
    final String? deskripsi;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Data({
        this.pemesananId,
        this.rating,
        this.review,
        this.deskripsi,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    Data copyWith({
        int? pemesananId,
        int? rating,
        String? review,
        String? deskripsi,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            pemesananId: pemesananId ?? this.pemesananId,
            rating: rating ?? this.rating,
            review: review ?? this.review,
            deskripsi: deskripsi ?? this.deskripsi,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        pemesananId: json["pemesanan_id"],
        rating: json["rating"],
        review: json["review"],
        deskripsi: json["deskripsi"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "pemesanan_id": pemesananId,
        "rating": rating,
        "review": review,
        "deskripsi": deskripsi,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
