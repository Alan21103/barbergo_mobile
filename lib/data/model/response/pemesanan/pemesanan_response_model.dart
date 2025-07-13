class PemesananResponseModel {
  final String? message;
  final int? statusCode;
  final PemesananData? data;

  PemesananResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  // Method untuk konversi JSON ke model
  factory PemesananResponseModel.fromJson(Map<String, dynamic> json) {
    return PemesananResponseModel(
      message: json['message'],
      statusCode: json['status_code'],
      data: json['data'] != null ? PemesananData.fromJson(json['data']) : null,
    );
  }

  // Static method untuk konversi dari Map (untuk digunakan di repository atau di tempat lain)
  static PemesananResponseModel fromMap(Map<String, dynamic> map) {
    return PemesananResponseModel(
      message: map['message'],
      statusCode: map['status_code'],
      data: map['data'] != null ? PemesananData.fromJson(map['data']) : null,
    );
  }

  // Method untuk konversi model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status_code': statusCode,
      'data': data?.toJson(),
    };
  }
}


class PemesananData {
  final int? id;
  final int? pelangganId;
  final int? barberId;
  final int? serviceId;
  final String? scheduledTime;
  final String? status;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final double? ongkir;

  PemesananData({
    this.id,
    this.pelangganId,
    this.barberId,
    this.serviceId,
    this.scheduledTime,
    this.status,
    this.alamat,
    this.latitude,
    this.longitude,
    this.ongkir,
  });

  factory PemesananData.fromJson(Map<String, dynamic> json) {
    return PemesananData(
      id: json['id'],
      pelangganId: json['pelanggan_id'],
      barberId: json['barber_id'],
      serviceId: json['service_id'],
      scheduledTime: json['scheduled_time'],
      status: json['status'],
      alamat: json['alamat'],
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null,
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null,
      ongkir: json['ongkir'] != null ? json['ongkir'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pelanggan_id': pelangganId,
      'barber_id': barberId,
      'service_id': serviceId,
      'scheduled_time': scheduledTime,
      'status': status,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'ongkir': ongkir,
    };
  }
}
