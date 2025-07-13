import 'dart:convert';

class ServiceRequestModel {
    final String? name;
    final String? description;
    final String? price;

    ServiceRequestModel({
        this.name,
        this.description,
        this.price,
    });

    ServiceRequestModel copyWith({
        String? name,
        String? description,
        String? price,
    }) => 
        ServiceRequestModel(
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
        );

    factory ServiceRequestModel.fromJson(String str) => ServiceRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ServiceRequestModel.fromMap(Map<String, dynamic> json) => ServiceRequestModel(
        name: json["name"],
        description: json["description"],
        price: json["price"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "price": price,
    };
}
