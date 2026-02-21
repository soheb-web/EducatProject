// To parse this JSON data, do
//
//     final getMyListModel = getMyListModelFromJson(jsonString);

import 'dart:convert';

GetMyListModel getMyListModelFromJson(String str) => GetMyListModel.fromJson(json.decode(str));

String getMyListModelToJson(GetMyListModel data) => json.encode(data.toJson());

class GetMyListModel {
  List<DatumMyList>? data;

  GetMyListModel({
    this.data,
  });

  factory GetMyListModel.fromJson(Map<String, dynamic> json) => GetMyListModel(
    data: json["data"] == null ? [] : List<DatumMyList>.from(json["data"]!.map((x) => DatumMyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumMyList {
  int? id;
  int? studentId;
  String? education;
  List<String>? subjects;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic location;
  String? teachingMode;
  String? duration;
  int? status;
  String? requires;
  String? budget;
  dynamic mobileNumber;
  dynamic time;
  String? gender;
  String? communicate;
  String? state;
  String? localAddress;
  String? pincode;
  Student? student;
  int? mentorCount;
  List<Mentor>? mentors;

  DatumMyList({
    this.id,
    this.studentId,
    this.education,
    this.subjects,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.teachingMode,
    this.duration,
    this.status,
    this.requires,
    this.budget,
    this.mobileNumber,
    this.time,
    this.gender,
    this.communicate,
    this.state,
    this.localAddress,
    this.pincode,
    this.student,
    this.mentorCount,
    this.mentors,
  });

  factory DatumMyList.fromJson(Map<String, dynamic> json) => DatumMyList(
    id: json["id"],
    studentId: json["student_id"],
    education: json["education"],
    subjects: json["subjects"] == null ? [] : List<String>.from(json["subjects"]!.map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    location: json["location"],
    teachingMode: json["teaching_mode"],
    duration: json["duration"],
    status: json["status"],
    requires: json["requires"],
    budget: json["budget"],
    mobileNumber: json["mobile_number"],
    time: json["time"],
    gender: json["gender"],
    communicate: json["communicate"],
    state: json["state"],
    localAddress: json["local_address"],
    pincode: json["pincode"],
    student: json["student"] == null ? null : Student.fromJson(json["student"]),
    mentorCount: json["mentor_count"],
    mentors: json["mentors"] == null ? [] : List<Mentor>.from(json["mentors"]!.map((x) => Mentor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "education": education,
    "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "location": location,
    "teaching_mode": teachingMode,
    "duration": duration,
    "status": status,
    "requires": requires,
    "budget": budget,
    "mobile_number": mobileNumber,
    "time": time,
    "gender": gender,
    "communicate": communicate,
    "state": state,
    "local_address": localAddress,
    "pincode": pincode,
    "student": student?.toJson(),
    "mentor_count": mentorCount,
    "mentors": mentors == null ? [] : List<dynamic>.from(mentors!.map((x) => x.toJson())),
  };
}

class Mentor {
  int? id;
  String? name;
  String? email;
  String? phone_number;
  String? status;
  String? mentor_status;

  Mentor({
    this.id,
    this.name,
    this.email,
    this.phone_number,
    this.status,
    this.mentor_status,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone_number: json["phone_number"],
    status: json["status"],
    mentor_status: json["mentor_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_number": phone_number,
    "status": status,
    "mentor_status": mentor_status,
  };
}

class Student {
  String? fullName;
  String? phoneNumber;
  String? profilePic;

  Student({
    this.fullName,
    this.phoneNumber,
    this.profilePic,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "phone_number": phoneNumber,
    "profile_pic": profilePic,
  };
}
