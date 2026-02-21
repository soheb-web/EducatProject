// To parse this JSON data, do
//
//     final getStudentRequestResModel = getStudentRequestResModelFromJson(jsonString);

import 'dart:convert';

GetStudentRequestResModel getStudentRequestResModelFromJson(String str) =>
    GetStudentRequestResModel.fromJson(json.decode(str));

String getStudentRequestResModelToJson(GetStudentRequestResModel data) =>
    json.encode(data.toJson());

class GetStudentRequestResModel {
  bool status;
  int total;
  List<Datum> data;

  GetStudentRequestResModel({
    required this.status,
    required this.total,
    required this.data,
  });

  factory GetStudentRequestResModel.fromJson(Map<String, dynamic> json) =>
      GetStudentRequestResModel(
        status: json["status"],
        total: json["total"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String status;
  int studentId;
  String studentName;
  String studentEmail;
  String studentPhone;
  String studentProfile;
  String studentType;

  Datum({
    required this.id,
    required this.status,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.studentPhone,
    required this.studentProfile,
    required this.studentType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        studentEmail: json["student_email"],
        studentPhone: json["student_phone"],
        studentProfile: json["student_profile"].toString(),
        studentType: json["student_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "student_id": studentId,
        "student_name": studentName,
        "student_email": studentEmail,
        "student_phone": studentPhone,
        "student_profile": studentProfile,
        "student_type": studentType,
      };
}
