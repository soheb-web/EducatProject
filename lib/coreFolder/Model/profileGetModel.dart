// To parse this JSON data, do
//
//     final profileGetModel = profileGetModelFromJson(jsonString);

import 'dart:convert';

ProfileGetModel profileGetModelFromJson(String str) =>
    ProfileGetModel.fromJson(json.decode(str));

String profileGetModelToJson(ProfileGetModel data) =>
    json.encode(data.toJson());

class ProfileGetModel {
  int? id;
  String? fullName;
  dynamic backgroundImage;
  String? profilePic;
  String? certificate;
  dynamic interest;
  dynamic usersField;
  String? description;
  String? totalExperience;
  List<String>? skills;
  String? languageKnown;
  String? linkedinUser;
  dynamic companiesWorked;
  String? resumeUpload;
  String? highestQualification;
  String? jobRole;
  String? jobLocation;
  String? jobCompanyName;
  dynamic collegeOrInstituteName;
  MentorRequest? mentorRequests;

  ProfileGetModel({
    this.id,
    this.fullName,
    this.backgroundImage,
    this.profilePic,
    this.certificate,
    this.interest,
    this.usersField,
    this.description,
    this.totalExperience,
    this.skills,
    this.languageKnown,
    this.linkedinUser,
    this.companiesWorked,
    this.resumeUpload,
    this.highestQualification,
    this.jobRole,
    this.jobLocation,
    this.jobCompanyName,
    this.collegeOrInstituteName,
    this.mentorRequests,
  });

  factory ProfileGetModel.fromJson(Map<String, dynamic> json) =>
      ProfileGetModel(
        id: json["id"],
        fullName: json["full_name"],
        backgroundImage: json["background_image"],
        profilePic: json["profile_pic"],
        certificate: json["certificate"],
        interest: json["interest"],
        usersField: json["users_field"],
        description: json["description"],
        totalExperience: json["total_experience"],
        skills: json["skills"] == null
            ? []
            : List<String>.from(json["skills"]!.map((x) => x)),
        languageKnown: json["language_known"],
        linkedinUser: json["linkedin_user"],
        companiesWorked: json["companies_worked"],
        resumeUpload: json["resume_upload"],
        highestQualification: json["highest_qualification"],
        jobRole: json["job_role"],
        jobLocation: json["job_location"],
        jobCompanyName: json["job_company_name"],
        collegeOrInstituteName: json["college_or_institute_name"],
        mentorRequests:
            json['mentorRequests'] != null && json['mentorRequests'] is Map
                ? MentorRequest.fromJson(json['mentorRequests'])
                : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "background_image": backgroundImage,
        "profile_pic": profilePic,
        "certificate": certificate,
        "interest": interest,
        "users_field": usersField,
        "description": description,
        "total_experience": totalExperience,
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "language_known": languageKnown,
        "linkedin_user": linkedinUser,
        "companies_worked": companiesWorked,
        "resume_upload": resumeUpload,
        "highest_qualification": highestQualification,
        "job_role": jobRole,
        "job_location": jobLocation,
        "job_company_name": jobCompanyName,
        "college_or_institute_name": collegeOrInstituteName,
        'mentorRequests': mentorRequests?.toJson(),
      };
}

class MentorRequest {
  int? id;
  int? studentId;
  int? mentorId;
  String? status;
  String? createdAt;
  String? updatedAt;

  MentorRequest({
    this.id,
    this.studentId,
    this.mentorId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MentorRequest.fromJson(Map<String, dynamic> json) {
    return MentorRequest(
      id: json['id'],
      studentId: json['student_id'],
      mentorId: json['mentor_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'mentor_id': mentorId,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
