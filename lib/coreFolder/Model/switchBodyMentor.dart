
import 'dart:convert';

SwitchBodyMentor SwitchBodyMentorFromJson(String str) =>
    SwitchBodyMentor.fromJson(json.decode(str));

String SwitchBodyMentorToJson(SwitchBodyMentor data) =>
    json.encode(data.toJson());

class SwitchBodyMentor {
  String user_type ;

  SwitchBodyMentor({
    required this.user_type ,
  });

  factory SwitchBodyMentor.fromJson(Map<String, dynamic> json) =>
      SwitchBodyMentor(
        user_type : json["user_type"],
      );

  Map<String, dynamic> toJson() => {
    "user_type": user_type ,
  };
}




// To parse this JSON data, do
//
//     final switchResponseModel = switchResponseModelFromJson(jsonString);


SwitchResponseModel switchResponseModelFromJson(String str) => SwitchResponseModel.fromJson(json.decode(str));

String switchResponseModelToJson(SwitchResponseModel data) => json.encode(data.toJson());

class SwitchResponseModel {
  bool? success;
  String? message;

  SwitchResponseModel({
    this.success,
    this.message,
  });

  factory SwitchResponseModel.fromJson(Map<String, dynamic> json) => SwitchResponseModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}







FollowUnfollowModel FollowUnfollowModelFromJson(String str) =>
    FollowUnfollowModel.fromJson(json.decode(str));

String FollowUnfollowModelToJson(SwitchBodyMentor data) =>
    json.encode(data.toJson());

class FollowUnfollowModel {
  int college_id ;

  FollowUnfollowModel({
    required this.college_id ,
  });

  factory FollowUnfollowModel.fromJson(Map<String, dynamic> json) =>
      FollowUnfollowModel(
        college_id : json["college_id"],
      );

  Map<String, dynamic> toJson() => {
    "college_id": college_id ,
  };
}



// To parse this JSON data, do
//
//     final followUnfollowResponseModel = followUnfollowResponseModelFromJson(jsonString);


FollowUnfollowResponseModel followUnfollowResponseModelFromJson(String str) => FollowUnfollowResponseModel.fromJson(json.decode(str));

String followUnfollowResponseModelToJson(FollowUnfollowResponseModel data) => json.encode(data.toJson());

class FollowUnfollowResponseModel {
  bool? status;
  String? action;

  FollowUnfollowResponseModel({
    this.status,
    this.action,
  });

  factory FollowUnfollowResponseModel.fromJson(Map<String, dynamic> json) => FollowUnfollowResponseModel(
    status: json["status"],
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "action": action,
  };
}






FollowUnfollowCompanyModel FollowUnfollowCompanyModelFromJson(String str) =>
    FollowUnfollowCompanyModel.fromJson(json.decode(str));

String FollowUnfollowCompanyModelToJson(SwitchBodyMentor data) =>
    json.encode(data.toJson());

class FollowUnfollowCompanyModel {
  int company_id ;

  FollowUnfollowCompanyModel({
    required this.company_id ,
  });

  factory FollowUnfollowCompanyModel.fromJson(Map<String, dynamic> json) =>
      FollowUnfollowCompanyModel(
        company_id : json["company_id"],
      );

  Map<String, dynamic> toJson() => {
    "company_id": company_id ,
  };
}

