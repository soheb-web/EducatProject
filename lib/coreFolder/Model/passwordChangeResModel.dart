// To parse this JSON data, do
//
//     final passwordChangeResModel = passwordChangeResModelFromJson(jsonString);

import 'dart:convert';

PasswordChangeResModel passwordChangeResModelFromJson(String str) => PasswordChangeResModel.fromJson(json.decode(str));

String passwordChangeResModelToJson(PasswordChangeResModel data) => json.encode(data.toJson());

class PasswordChangeResModel {
    String message;

    PasswordChangeResModel({
        required this.message,
    });

    factory PasswordChangeResModel.fromJson(Map<String, dynamic> json) => PasswordChangeResModel(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
