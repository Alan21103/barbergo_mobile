import 'dart:convert';

class GetAllServiceModel {
    final int? id;
    final String? name;
    final String? description;
    final String? price;
    final DateTime? createdAt;
    final DateTime? updatedAt;
     final int? barberId;

    GetAllServiceModel({
        this.id,
        this.name,
        this.description,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.barberId
    });

    GetAllServiceModel copyWith({
        int? id,
        String? name,
        String? description,
        String? price,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? barberId
    }) => 
        GetAllServiceModel(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            barberId: barberId ?? this.barberId
        );

    factory GetAllServiceModel.fromJson(String str) => GetAllServiceModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetAllServiceModel.fromMap(Map<String, dynamic> json) => GetAllServiceModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        barberId: json["barber_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "barber_id": barberId
    };
}
