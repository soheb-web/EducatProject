// To parse this JSON data, do something like this:
//
//     final MentorrequestApplyBody = MentorrequestApplyBodyFromJson(jsonString);

import 'dart:convert';

MentorrequestApplyBody MentorrequestApplyBodyFromJson(String str) =>
    MentorrequestApplyBody.fromJson(json.decode(str));

String MentorrequestApplyBodyToJson(MentorrequestApplyBody data) => json.encode(data.toJson());

class MentorrequestApplyBody {
  int? mentorId;
  String? title;
  String? body;
  int? student_lists_id;
  String? mentorStatus;

  MentorrequestApplyBody({
    this.mentorId,
    this.title,
    this.body,
    this.student_lists_id,
    this.mentorStatus,
  });

  factory MentorrequestApplyBody.fromJson(Map<String, dynamic> json) {
    return MentorrequestApplyBody(
      mentorId: json["mentor_id"] as int?,
      title: json["title"] as String?,
      body: json["body"] as String?,
      student_lists_id: json["student_lists_id"],
      mentorStatus: json["mentor_status"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mentor_id": mentorId,
      "title": title,
      "body": body,
      "student_lists_id": student_lists_id,
      "mentor_status": mentorStatus,
    }..removeWhere((key, value) => value == null);
  }

  // Optional: cleaner version if you want to include null fields explicitly
  Map<String, dynamic> toJsonWithNulls() {
    return {
      "mentor_id": mentorId,
      "title": title,
      "body": body,
      // "data": data,
      "mentor_status": mentorStatus,
    };
  }
}