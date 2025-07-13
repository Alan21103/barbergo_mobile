import 'dart:convert';

class AdminProfileRequestModel {
  final String? name;
  final String? alamat;
  final double? latitude;
  final double? longitude;

  AdminProfileRequestModel({
    this.name,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  AdminProfileRequestModel copyWith({
    String? name,
    String? alamat,
    double? latitude,
    double? longitude,
  }) =>
      AdminProfileRequestModel(
        name: name ?? this.name,
        alamat: alamat ?? this.alamat,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  // Convert JSON to AdminProfileRequestModel
  factory AdminProfileRequestModel.fromJson(String str) =>
      AdminProfileRequestModel.fromMap(json.decode(str));

  // Convert AdminProfileRequestModel to JSON
  String toJson() => json.encode(toMap());

  // Convert Map to AdminProfileRequestModel
  factory AdminProfileRequestModel.fromMap(Map<String, dynamic> json) =>
      AdminProfileRequestModel(
        name: json["name"],
        alamat: json["alamat"],
        latitude: _parseDouble(json["latitude"]),
        longitude: _parseDouble(json["longitude"]),
      );

  // Map the AdminProfileRequestModel to Map
  Map<String, dynamic> toMap() => {
        "name": name,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
      };

  // Helper function to parse latitude and longitude
  static double? _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value);
    } else if (value is double) {
      return value;
    }
    return null;
  }
}
