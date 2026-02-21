// To parse this JSON data, do
//
//     final MentorBodyNotification = MentorBodyNotificationFromJson(jsonString);

import 'dart:convert';

MentorBodyNotification MentorBodyNotificationFromJson(String str) =>
    MentorBodyNotification.fromJson(json.decode(str));

String MentorBodyNotificationToJson(MentorBodyNotification data) =>
    json.encode(data.toJson());

class MentorBodyNotification {

  String title;
  String body;
  String user_id;

  MentorBodyNotification({

    required this.title,
    required this.body,
    required this.user_id,
  });

  factory MentorBodyNotification.fromJson(Map<String, dynamic> json) =>
      MentorBodyNotification(

        title: json["title"],
        body: json["body"],
        user_id: json['user_id'],
      );

  Map<String, dynamic> toJson() => {

    "title": title,
    "body": body,
    'user_id': user_id
  };
}
