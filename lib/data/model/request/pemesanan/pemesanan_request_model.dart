import 'dart:convert';

class PemesananRequestModel {
    // final int? barberId;
    final int? adminId;
    final int? serviceId;
    final DateTime? scheduledTime;
    final String? alamat;
    final double? latitude;
    final double? longitude;

    PemesananRequestModel({
        // this.barberId,
        this.adminId,
        this.serviceId,
        this.scheduledTime,
        this.alamat,
        this.latitude,
        this.longitude,
    });

    PemesananRequestModel copyWith({
        // int? barberId,
        int? adminId,
        int? serviceId,
        DateTime? scheduledTime,
        String? alamat,
        double? latitude,
        double? longitude,
    }) => 
        PemesananRequestModel(
            // barberId: barberId ?? this.barberId,
            adminId: adminId ?? this.adminId,
            serviceId: serviceId ?? this.serviceId,
            scheduledTime: scheduledTime ?? this.scheduledTime,
            alamat: alamat ?? this.alamat,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
        );

    factory PemesananRequestModel.fromJson(String str) => PemesananRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PemesananRequestModel.fromMap(Map<String, dynamic> json) => PemesananRequestModel(
        // barberId: json["barber_id"],
        adminId: json["admin_id"],
        serviceId: json["service_id"],
        scheduledTime: json["scheduled_time"] == null ? null : DateTime.parse(json["scheduled_time"]),
        alamat: json["alamat"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        // "barber_id": barberId,
        "admin_id": adminId,
        "service_id": serviceId,
        "scheduled_time": scheduledTime?.toIso8601String(),
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
    };
}
