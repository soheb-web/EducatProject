// To parse this JSON data, do
//
//     final passwordChangeBodyModel = passwordChangeBodyModelFromJson(jsonString);

import 'dart:convert';

PasswordChangeBodyModel passwordChangeBodyModelFromJson(String str) => PasswordChangeBodyModel.fromJson(json.decode(str));

String passwordChangeBodyModelToJson(PasswordChangeBodyModel data) => json.encode(data.toJson());

class PasswordChangeBodyModel {
    String oldPassword;
    String newPassword;
    String newPasswordConfirmation;

    PasswordChangeBodyModel({
        required this.oldPassword,
        required this.newPassword,
        required this.newPasswordConfirmation,
    });

    factory PasswordChangeBodyModel.fromJson(Map<String, dynamic> json) => PasswordChangeBodyModel(
        oldPassword: json["old_password"],
        newPassword: json["new_password"],
        newPasswordConfirmation: json["new_password_confirmation"],
    );

    Map<String, dynamic> toJson() => {
        "old_password": oldPassword,
        "new_password": newPassword,
        "new_password_confirmation": newPasswordConfirmation,
    };
}
