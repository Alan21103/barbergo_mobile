import 'dart:convert';

class PortofolioResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    PortofolioResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    PortofolioResponseModel copyWith({
        int? statusCode,
        String? message,
        Data? data,
    }) => 
        PortofolioResponseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory PortofolioResponseModel.fromJson(String str) => PortofolioResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PortofolioResponseModel.fromMap(Map<String, dynamic> json) => PortofolioResponseModel(
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
    final int? barberId;
    final String? image;
    final String? description;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Data({
        this.barberId,
        this.image,
        this.description,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    Data copyWith({
        int? barberId,
        String? image,
        String? description,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            barberId: barberId ?? this.barberId,
            image: image ?? this.image,
            description: description ?? this.description,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        barberId: json["barber_id"],
        image: json["image"],
        description: json["description"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "barber_id": barberId,
        "image": image,
        "description": description,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
