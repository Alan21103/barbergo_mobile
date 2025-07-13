import 'dart:convert';

class GetAllAdminResponseModel {
    final String? message;
    final int? statusCode;
    final List<AdminDatum>? data;

    GetAllAdminResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    GetAllAdminResponseModel copyWith({
        String? message,
        int? statusCode,
        List<AdminDatum>? data,
    }) => 
        GetAllAdminResponseModel(
            message: message ?? this.message,
            statusCode: statusCode ?? this.statusCode,
            data: data ?? this.data,
        );

    factory GetAllAdminResponseModel.fromJson(String str) => GetAllAdminResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllAdminResponseModel.fromMap(Map<String, dynamic> json) => GetAllAdminResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<AdminDatum>.from(json["data"]!.map((x) => AdminDatum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class AdminDatum {
    final int? id;
    final int? userId;
    final String? name;
    final String? alamat;
    final String? latitude;
    final String? longitude;

    AdminDatum({
        this.id,
        this.userId,
        this.name,
        this.alamat,
        this.latitude,
        this.longitude,
    });

    AdminDatum copyWith({
        int? id,
        int? userId,
        String? name,
        String? alamat,
        String? latitude,
        String? longitude,
    }) => 
        AdminDatum(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            name: name ?? this.name,
            alamat: alamat ?? this.alamat,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
        );

    factory AdminDatum.fromJson(String str) => AdminDatum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AdminDatum.fromMap(Map<String, dynamic> json) => AdminDatum(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        alamat: json["alamat"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
    };
}
