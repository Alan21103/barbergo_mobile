import 'dart:convert';

class GetAllJadwalResponseModel {
    final int? statusCode;
    final String? message;
    final List<JadwalDatum>? data;

    GetAllJadwalResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    GetAllJadwalResponseModel copyWith({
        int? statusCode,
        String? message,
        List<JadwalDatum>? data,
    }) => 
        GetAllJadwalResponseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetAllJadwalResponseModel.fromJson(String str) => GetAllJadwalResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllJadwalResponseModel.fromMap(Map<String, dynamic> json) => GetAllJadwalResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<JadwalDatum>.from(json["data"]!.map((x) => JadwalDatum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class JadwalDatum {
    final int? id;
    final int? barberId;
    final String? hari;
    final String? tersediaDari;
    final String? tersediaHingga;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    JadwalDatum({
        this.id,
        this.barberId,
        this.hari,
        this.tersediaDari,
        this.tersediaHingga,
        this.createdAt,
        this.updatedAt,
    });

    JadwalDatum copyWith({
        int? id,
        int? barberId,
        String? hari,
        String? tersediaDari,
        String? tersediaHingga,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        JadwalDatum(
            id: id ?? this.id,
            barberId: barberId ?? this.barberId,
            hari: hari ?? this.hari,
            tersediaDari: tersediaDari ?? this.tersediaDari,
            tersediaHingga: tersediaHingga ?? this.tersediaHingga,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory JadwalDatum.fromJson(String str) => JadwalDatum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory JadwalDatum.fromMap(Map<String, dynamic> json) => JadwalDatum(
        id: json["id"],
        barberId: json["barber_id"],
        hari: json["hari"],
        tersediaDari: json["tersedia_dari"],
        tersediaHingga: json["tersedia_hingga"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "barber_id": barberId,
        "hari": hari,
        "tersedia_dari": tersediaDari,
        "tersedia_hingga": tersediaHingga,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
