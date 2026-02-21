// To parse this JSON data, do
//
//     final userProfileResModel = userProfileResModelFromJson(jsonString);

import 'dart:convert';

UserProfileResModel userProfileResModelFromJson(String str) =>
    UserProfileResModel.fromJson(json.decode(str));

String userProfileResModelToJson(UserProfileResModel data) =>
    json.encode(data.toJson());

class UserProfileResModel {
  String? message;
  Data? data;

  UserProfileResModel({
    this.message,
    this.data,
  });

  factory UserProfileResModel.fromJson(Map<String, dynamic> json) =>
      UserProfileResModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? deviceToken;
  dynamic token;
  String? profilePic;
  String? userType;
  String? studentId;
  String? experienceLetter;
  String? serviceType;
  String? description;
  String? skillsId;
  String? totalExperience;
  String? usersField;
  String? languageKnown;
  String? linkedinUser;
  DateTime? dob;
  String? gender;
  String? resumeUpload;
  String? coins;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  String? statusMentor;
  String? educationYear;
  String? collegeOrInstituteName;
  String? highestQualification;
  String? jobRole;
  String? jobLocation;
  String? jobCompanyName;
  String? salary;
  String? experienceLetterStatus;
  String? studentIdStatus;
  String? certificate;
  List<String>? interest;
  List<String>? skills;
  dynamic backgroundImage;

  Data({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.deviceToken,
    this.token,
    this.profilePic,
    this.userType,
    this.studentId,
    this.experienceLetter,
    this.serviceType,
    this.description,
    this.skillsId,
    this.totalExperience,
    this.usersField,
    this.languageKnown,
    this.linkedinUser,
    this.dob,
    this.gender,
    this.resumeUpload,
    this.coins,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.statusMentor,
    this.educationYear,
    this.collegeOrInstituteName,
    this.highestQualification,
    this.jobRole,
    this.jobLocation,
    this.jobCompanyName,
    this.salary,
    this.experienceLetterStatus,
    this.studentIdStatus,
    this.certificate,
    this.interest,
    this.skills,
    this.backgroundImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        deviceToken: json["device_token"],
        token: json["token"],
        profilePic: json["profile_pic"],
        userType: json["user_type"],
        studentId: json["student_id"],
        experienceLetter: json["experience_letter"],
        serviceType: json["service_type"],
        description: json["description"],
        skillsId: json["skills_id"],
        totalExperience: json["total_experience"],
        usersField: json["users_field"],
        languageKnown: json["language_known"],
        linkedinUser: json["linkedin_user"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        resumeUpload: json["resume_upload"],
        coins: json["coins"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"],
        statusMentor: json["status_mentor"],
        educationYear: json["education_year"],
        collegeOrInstituteName: json["college_or_institute_name"],
        highestQualification: json["highest_qualification"],
        jobRole: json["job_role"],
        jobLocation: json["job_location"],
        jobCompanyName: json["job_company_name"],
        salary: json["salary"],
        experienceLetterStatus: json["experience_letter_status"],
        studentIdStatus: json["student_id_status"],
        certificate: json["certificate"],
        interest: json["interest"] == null
            ? []
            : List<String>.from(json["interest"]!.map((x) => x)),
        skills: json["skills"] == null
            ? []
            : List<String>.from(json["skills"]!.map((x) => x)),
        backgroundImage: json["background_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "device_token": deviceToken,
        "token": token,
        "profile_pic": profilePic,
        "user_type": userType,
        "student_id": studentId,
        "experience_letter": experienceLetter,
        "service_type": serviceType,
        "description": description,
        "skills_id": skillsId,
        "total_experience": totalExperience,
        "users_field": usersField,
        "language_known": languageKnown,
        "linkedin_user": linkedinUser,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "resume_upload": resumeUpload,
        "coins": coins,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "status_mentor": statusMentor,
        "education_year": educationYear,
        "college_or_institute_name": collegeOrInstituteName,
        "highest_qualification": highestQualification,
        "job_role": jobRole,
        "job_location": jobLocation,
        "job_company_name": jobCompanyName,
        "salary": salary,
        "experience_letter_status": experienceLetterStatus,
        "student_id_status": studentIdStatus,
        "certificate": certificate,
        "interest":
            interest == null ? [] : List<dynamic>.from(interest!.map((x) => x)),
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "background_image": backgroundImage,
      };
}
