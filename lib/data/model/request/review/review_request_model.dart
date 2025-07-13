import 'dart:convert';

class ReviewRequestModel {
    final int? rating;
    final String? review;
    final String? deskripsi;

    ReviewRequestModel({
        this.rating,
        this.review,
        this.deskripsi,
    });

    ReviewRequestModel copyWith({
        int? rating,
        String? review,
        String? deskripsi,
    }) => 
        ReviewRequestModel(
            rating: rating ?? this.rating,
            review: review ?? this.review,
            deskripsi: deskripsi ?? this.deskripsi,
        );

    factory ReviewRequestModel.fromJson(String str) => ReviewRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReviewRequestModel.fromMap(Map<String, dynamic> json) => ReviewRequestModel(
        rating: json["rating"],
        review: json["review"],
        deskripsi: json["deskripsi"],
    );

    Map<String, dynamic> toMap() => {
        "rating": rating,
        "review": review,
        "deskripsi": deskripsi,
    };
}
