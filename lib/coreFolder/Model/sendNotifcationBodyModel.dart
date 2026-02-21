// To parse this JSON data, do
//
//     final sendNotifcationBodyModel = sendNotifcationBodyModelFromJson(jsonString);

import 'dart:convert';

SendNotifcationBodyModel sendNotifcationBodyModelFromJson(String str) =>
    SendNotifcationBodyModel.fromJson(json.decode(str));

String sendNotifcationBodyModelToJson(SendNotifcationBodyModel data) =>
    json.encode(data.toJson());

class SendNotifcationBodyModel {

  String title;
  String body;
  String mentorId;

  SendNotifcationBodyModel({
    required this.title,
    required this.body,
    required this.mentorId,
  });

  factory SendNotifcationBodyModel.fromJson(Map<String, dynamic> json) =>
      SendNotifcationBodyModel(

        title: json["title"],
        body: json["body"],
        mentorId: json['mentor_id'],
      );

  Map<String, dynamic> toJson() => {

        "title": title,
        "body": body,
        'mentor_id': mentorId
      };
}






