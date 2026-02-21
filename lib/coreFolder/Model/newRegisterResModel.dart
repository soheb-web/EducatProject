// To parse this JSON data, do
//
//     final newRegisterResModel = newRegisterResModelFromJson(jsonString);

import 'dart:convert';

NewRegisterResModel newRegisterResModelFromJson(String str) =>
    NewRegisterResModel.fromJson(json.decode(str));

String newRegisterResModelToJson(NewRegisterResModel data) =>
    json.encode(data.toJson());

class NewRegisterResModel {
  String message;
  Data data;

  NewRegisterResModel({
    required this.message,
    required this.data,
  });

  factory NewRegisterResModel.fromJson(Map<String, dynamic> json) =>
      NewRegisterResModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String fullName;
  String email;
  String phoneNumber;
  String serviceType;
  String userType;
  String profilePic;
  String studentId;
  DateTime? dob;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String experience_letter;

  Data({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.serviceType,
    required this.userType,
    required this.profilePic,
    required this.studentId,
    this.dob,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.experience_letter,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        serviceType: json["service_type"],
        userType: json["user_type"],
        profilePic: json["profile_pic"].toString(),
        studentId: json["student_id"],
        dob: json["dob"] != null
            ? DateTime.tryParse(json["dob"].toString())
            : null,
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    experience_letter: json["experience_letter"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "service_type": serviceType,
        "user_type": userType,
        "profile_pic": profilePic,
        "student_id": studentId,
        "dob": dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "experience_letter": experience_letter,
      };
}
