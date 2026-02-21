// To parse this JSON data, do
//
//     final mentorReviewResModel = mentorReviewResModelFromJson(jsonString);

import 'dart:convert';

MentorReviewResModel mentorReviewResModelFromJson(String str) =>
    MentorReviewResModel.fromJson(json.decode(str));

String mentorReviewResModelToJson(MentorReviewResModel data) =>
    json.encode(data.toJson());

class MentorReviewResModel {
  bool? status;
  String? message;
  Data? data;

  MentorReviewResModel({
    this.status,
    this.message,
    this.data,
  });

  factory MentorReviewResModel.fromJson(Map<String, dynamic> json) =>
      MentorReviewResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? userId;
  String? mentorId;
  String? description;
  int? rating;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.userId,
    this.mentorId,
    this.description,
    this.rating,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        mentorId: json["mentor_id"],
        description: json["description"],
        rating: json["rating"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "mentor_id": mentorId,
        "description": description,
        "rating": rating,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}

// To parse this JSON data, do
//
//     final mentorReviewBodyModel = mentorReviewBodyModelFromJson(jsonString);

MentorReviewBodyModel mentorReviewBodyModelFromJson(String str) =>
    MentorReviewBodyModel.fromJson(json.decode(str));

String mentorReviewBodyModelToJson(MentorReviewBodyModel data) =>
    json.encode(data.toJson());

class MentorReviewBodyModel {
  String? mentorId;
  String? description;
  int? rating;

  MentorReviewBodyModel({
    this.mentorId,
    this.description,
    this.rating,
  });

  factory MentorReviewBodyModel.fromJson(Map<String, dynamic> json) =>
      MentorReviewBodyModel(
        mentorId: json["mentor_id"],
        description: json["description"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "mentor_id": mentorId,
        "description": description,
        "rating": rating,
      };
}
