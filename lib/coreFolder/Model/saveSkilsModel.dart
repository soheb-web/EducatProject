// To parse this JSON data, do
//
//     final saveSkillBodyModel = saveSkillBodyModelFromJson(jsonString);

import 'dart:convert';

SaveSkillBodyModel saveSkillBodyModelFromJson(String str) => SaveSkillBodyModel.fromJson(json.decode(str));

String saveSkillBodyModelToJson(SaveSkillBodyModel data) => json.encode(data.toJson());

class SaveSkillBodyModel {
    int? skillId;

    SaveSkillBodyModel({
        this.skillId,
    });

    factory SaveSkillBodyModel.fromJson(Map<String, dynamic> json) => SaveSkillBodyModel(
        skillId: json["skill_id"],
    );

    Map<String, dynamic> toJson() => {
        "skill_id": skillId,
    };
}




// To parse this JSON data, do
//
//     final saveSkillResModel = saveSkillResModelFromJson(jsonString);



SaveSkillResModel saveSkillResModelFromJson(String str) => SaveSkillResModel.fromJson(json.decode(str));

String saveSkillResModelToJson(SaveSkillResModel data) => json.encode(data.toJson());

class SaveSkillResModel {
    bool? status;
    String? message;

    SaveSkillResModel({
        this.status,
        this.message,
    });

    factory SaveSkillResModel.fromJson(Map<String, dynamic> json) => SaveSkillResModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
