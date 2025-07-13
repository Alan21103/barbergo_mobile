import 'dart:convert';

class LoginResponseModel {
    final String? message;
    final int? statusCode;
    final User? user;

    LoginResponseModel({
        this.message,
        this.statusCode,
        this.user,
    });

    factory LoginResponseModel.fromJson(String str) => LoginResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LoginResponseModel.fromMap(Map<String, dynamic> json) => LoginResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        user: json["User"] == null ? null : User.fromMap(json["User"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "User": user?.toMap(),
    };
}

class User {
    final int? id;
    final String? name;
    final String? email;
    final String? role;
    final String? token;

    User({
        this.id,
        this.name,
        this.email,
        this.role,
        this.token,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "token": token,
    };
}
