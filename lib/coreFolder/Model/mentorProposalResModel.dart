// To parse this JSON data, do
//
//     final mentorproposalResModel = mentorproposalResModelFromJson(jsonString);

import 'dart:convert';

MentorproposalResModel mentorproposalResModelFromJson(String str) =>
    MentorproposalResModel.fromJson(json.decode(str));

String mentorproposalResModelToJson(MentorproposalResModel data) =>
    json.encode(data.toJson());

class MentorproposalResModel {
  bool? success;
  int? studentId;
  int? totalMentors;
  List<Datum>? data;

  MentorproposalResModel({
    this.success,
    this.studentId,
    this.totalMentors,
    this.data,
  });

  factory MentorproposalResModel.fromJson(Map<String, dynamic> json) =>
      MentorproposalResModel(
        success: json["success"],
        studentId: json["student_id"],
        totalMentors: json["total_mentors"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "student_id": studentId,
        "total_mentors": totalMentors,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? title;
  String? body;
  int? notificationCount;

  Datum({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.title,
    this.body,
    this.notificationCount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        title: json["title"],
        body: json["body"],
        notificationCount: json["notification_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "title": title,
        "body": body,
        "notification_count": notificationCount,
      };
}
