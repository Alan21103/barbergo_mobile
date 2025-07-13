import 'dart:convert';

class GetAllPortofoliosResponseModel {
    final int? statusCode;
    final String? message;
    final List<PortofolioDatum>? data;

    GetAllPortofoliosResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    GetAllPortofoliosResponseModel copyWith({
        int? statusCode,
        String? message,
        List<PortofolioDatum>? data,
    }) => 
        GetAllPortofoliosResponseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetAllPortofoliosResponseModel.fromJson(String str) => GetAllPortofoliosResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllPortofoliosResponseModel.fromMap(Map<String, dynamic> json) => GetAllPortofoliosResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PortofolioDatum>.from(json["data"]!.map((x) => PortofolioDatum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class PortofolioDatum {
    final int? id;
    final int? barberId;
    final String? image;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Barber? barber;

    PortofolioDatum({
        this.id,
        this.barberId,
        this.image,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.barber,
    });

    PortofolioDatum copyWith({
        int? id,
        int? barberId,
        String? image,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        Barber? barber,
    }) => 
        PortofolioDatum(
            id: id ?? this.id,
            barberId: barberId ?? this.barberId,
            image: image ?? this.image,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            barber: barber ?? this.barber,
        );

    factory PortofolioDatum.fromJson(String str) => PortofolioDatum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PortofolioDatum.fromMap(Map<String, dynamic> json) => PortofolioDatum(
        id: json["id"],
        barberId: json["barber_id"],
        image: json["image"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        barber: json["barber"] == null ? null : Barber.fromMap(json["barber"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "barber_id": barberId,
        "image": image,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "barber": barber?.toMap(),
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
