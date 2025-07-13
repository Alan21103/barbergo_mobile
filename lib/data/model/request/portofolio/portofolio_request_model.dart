import 'dart:convert';

class PortofolioRequestModel {
  final String? image; // Menggunakan String untuk merepresentasikan gambar (misal: Base64 string atau URL)
  final String? description;

  PortofolioRequestModel({
    this.image,
    this.description,
  });

  // Metode copyWith untuk memudahkan pembuatan instance baru dengan perubahan parsial
  PortofolioRequestModel copyWith({
    String? image,
    String? description,
  }) =>
      PortofolioRequestModel(
        image: image ?? this.image,
        description: description ?? this.description,
      );

  // Factory constructor untuk membuat instance dari JSON string
  factory PortofolioRequestModel.fromJson(String str) =>
      PortofolioRequestModel.fromMap(json.decode(str));

  // Metode untuk mengkonversi instance menjadi JSON string
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory PortofolioRequestModel.fromMap(Map<String, dynamic> json) =>
      PortofolioRequestModel(
        image: json["image"],
        description: json["description"],
      );

  // Metode untuk mengkonversi instance menjadi Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "image": image,
        "description": description,
      };
}
