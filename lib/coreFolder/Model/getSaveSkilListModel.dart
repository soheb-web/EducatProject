// To parse this JSON data, do
//
//     final getSaveSkilListModel = getSaveSkilListModelFromJson(jsonString);

import 'dart:convert';

GetSaveSkilListModel getSaveSkilListModelFromJson(String str) =>
    GetSaveSkilListModel.fromJson(json.decode(str));

String getSaveSkilListModelToJson(GetSaveSkilListModel data) =>
    json.encode(data.toJson());

class GetSaveSkilListModel {
  bool? status;
  List<Datum>? data;

  GetSaveSkilListModel({
    this.status,
    this.data,
  });

  factory GetSaveSkilListModel.fromJson(Map<String, dynamic> json) =>
      GetSaveSkilListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? skillsId;
  String? userName;
  String? image;
  String? title;
  String? level;
  dynamic industry;
  String? subTitle;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.skillsId,
    this.userName,
    this.image,
    this.title,
    this.level,
    this.industry,
    this.subTitle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        skillsId: json['skills_id'],
        userName: json["user_name"],
        image: json["image"],
        title: json["title"],
        level: json["level"],
        industry: json["industry"],
        subTitle: json["sub_title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "skills_id": skillsId,
        "user_name": userName,
        "image": image,
        "title": title,
        "level": level,
        "industry": industry,
        "sub_title": subTitle,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
