// To parse this JSON data, do
//
//     final getNotificationResModel = getNotificationResModelFromJson(jsonString);

import 'dart:convert';

GetNotificationResModel getNotificationResModelFromJson(String str) => GetNotificationResModel.fromJson(json.decode(str));

String getNotificationResModelToJson(GetNotificationResModel data) => json.encode(data.toJson());

class GetNotificationResModel {
    bool? success;
    int? mentorId;
    int? totalUsers;
    List<Datum>? data;

    GetNotificationResModel({
        this.success,
        this.mentorId,
        this.totalUsers,
        this.data,
    });

    factory GetNotificationResModel.fromJson(Map<String, dynamic> json) => GetNotificationResModel(
        success: json["success"],
        mentorId: json["mentor_id"],
        totalUsers: json["total_users"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "mentor_id": mentorId,
        "total_users": totalUsers,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? fullName;
    String? email;
    String? title;
    String? body;
    int? notificationCount;

    Datum({
        this.id,
        this.fullName,
        this.email,
        this.title,
        this.body,
        this.notificationCount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        title: json["title"],
        body: json["body"],
        notificationCount: json["notification_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "title": title,
        "body": body,
        "notification_count": notificationCount,
    };
}
