// To parse this JSON data, do
//
//     final sendRequestResModel = sendRequestResModelFromJson(jsonString);

import 'dart:convert';

SendRequestResModel sendRequestResModelFromJson(String str) => SendRequestResModel.fromJson(json.decode(str));

String sendRequestResModelToJson(SendRequestResModel data) => json.encode(data.toJson());

class SendRequestResModel {
    bool status;
    String message;

    SendRequestResModel({
        required this.status,
        required this.message,
    });

    factory SendRequestResModel.fromJson(Map<String, dynamic> json) => SendRequestResModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}


// To parse this JSON data, do
//
//     final acceptRequestResModel = acceptRequestResModelFromJson(jsonString);



AcceptRequestResModel acceptRequestResModelFromJson(String str) => AcceptRequestResModel.fromJson(json.decode(str));

String acceptRequestResModelToJson(AcceptRequestResModel data) => json.encode(data.toJson());

class AcceptRequestResModel {
    bool status;
    String message;

    AcceptRequestResModel({
        required this.status,
        required this.message,
    });

    factory AcceptRequestResModel.fromJson(Map<String, dynamic> json) => AcceptRequestResModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
