import 'dart:convert';

class PelangganProfileRequestModel {
  final String? name;
  final String? address;
  final String? phone;
  final String? photo;

  PelangganProfileRequestModel({this.name, this.address, this.phone, this.photo});

  factory PelangganProfileRequestModel.fromJson(String str) =>
      PelangganProfileRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PelangganProfileRequestModel.fromMap(Map<String, dynamic> json) =>
      PelangganProfileRequestModel(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "address": address,
    "phone": phone,
    "photo": photo,
  };
}