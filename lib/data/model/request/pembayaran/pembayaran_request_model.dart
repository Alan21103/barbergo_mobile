import 'dart:convert';

class PembayaranRequestModel {
    final int? pemesananId;
    final double? amount;
    final String? status;
    final String? via;

    PembayaranRequestModel({
        this.pemesananId,
        this.amount,
        this.status,
        this.via,
    });

    PembayaranRequestModel copyWith({
        int? pemesananId,
        double? amount,
        String? status,
        String? via,
    }) => 
        PembayaranRequestModel(
            pemesananId: pemesananId ?? this.pemesananId,
            amount: amount ?? this.amount,
            status: status ?? this.status,
            via: via ?? this.via,
        );

    factory PembayaranRequestModel.fromJson(String str) => PembayaranRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PembayaranRequestModel.fromMap(Map<String, dynamic> json) => PembayaranRequestModel(
        pemesananId: json["pemesanan_id"],
        amount: json["amount"]?.toDouble(),
        status: json["status"],
        via: json["via"],
    );

    Map<String, dynamic> toMap() => {
        "pemesanan_id": pemesananId,
        "amount": amount,
        "status": status,
        "via": via,
    };
}
