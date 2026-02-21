// To parse this JSON data, do
//
//     final reportResModel = reportResModelFromJson(jsonString);

import 'dart:convert';

ReportResModel reportResModelFromJson(String str) =>
    ReportResModel.fromJson(json.decode(str));

String reportResModelToJson(ReportResModel data) => json.encode(data.toJson());

class ReportResModel {
  String? message;
  Data? data;

  ReportResModel({
    this.message,
    this.data,
  });

  factory ReportResModel.fromJson(Map<String, dynamic> json) => ReportResModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? reporterId;
  String? reportedId;
  String? reason;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;

  Data({
    this.reporterId,
    this.reportedId,
    this.reason,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reporterId: json["reporter_id"],
        reportedId: json["reported_id"],
        reason: json["reason"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "reporter_id": reporterId,
        "reported_id": reportedId,
        "reason": reason,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}

// To parse this JSON data, do
//
//     final reportBodyModel = reportBodyModelFromJson(jsonString);

ReportBodyModel reportBodyModelFromJson(String str) =>
    ReportBodyModel.fromJson(json.decode(str));

String reportBodyModelToJson(ReportBodyModel data) =>
    json.encode(data.toJson());

class ReportBodyModel {
  String? reportedId;
  String? reason;

  ReportBodyModel({
    this.reportedId,
    this.reason,
  });

  factory ReportBodyModel.fromJson(Map<String, dynamic> json) =>
      ReportBodyModel(
        reportedId: json["reported_id"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "reported_id": reportedId,
        "reason": reason,
      };
}
