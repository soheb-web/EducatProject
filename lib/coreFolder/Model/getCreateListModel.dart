import 'dart:convert';

GetcreatelistModel getcreatelistModelFromJson(String str) =>
    GetcreatelistModel.fromJson(json.decode(str));

String getcreatelistModelToJson(GetcreatelistModel data) =>
    json.encode(data.toJson());

class GetcreatelistModel {
  List<Datum>? data;

  GetcreatelistModel({this.data});

  factory GetcreatelistModel.fromJson(Map<String, dynamic> json) {
    return GetcreatelistModel(
      data: json["data"] == null || json["data"] is! List
          ? []
          : List<Datum>.from(
        (json["data"] as List).map(
              (x) => x is Map<String, dynamic> ? Datum.fromJson(x) : null,
        ).whereType<Datum>(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? studentId;
  String? education;
  List<String>? subjects;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? location;
  String? teachingMode;
  String? duration;
  int? status;
  String? requires;
  String? budget;
  String? mobileNumber;
  String? time;
  String? gender;
  String? communicate;
  String? state;
  String? localAddress;
  String? pincode;
  Student? student;
  List<Mentor>? mentors;

  Datum({
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
    this.mentors,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: _parseInt(json["id"]),
    studentId: _parseInt(json["student_id"]),
    education: json["education"]?.toString(),
    subjects: _parseStringList(json["subjects"]),
    createdAt: _parseDate(json["created_at"]),
    updatedAt: _parseDate(json["updated_at"]),
    location: json["location"]?.toString(),
    teachingMode: json["teaching_mode"]?.toString(),
    duration: json["duration"]?.toString(),
    status: _parseInt(json["status"]),
    requires: json["requires"]?.toString(),
    budget: json["budget"]?.toString(),
    mobileNumber: json["mobile_number"]?.toString(),
    time: json["time"]?.toString(),
    gender: json["gender"]?.toString(),
    communicate: json["communicate"]?.toString(),
    state: json["state"]?.toString(),
    localAddress: json["local_address"]?.toString(),
    pincode: json["pincode"]?.toString(),
    student: json["student"] is Map<String, dynamic>
        ? Student.fromJson(json["student"] as Map<String, dynamic>)
        : null,
    mentors: _parseMentorList(json["mentors"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "education": education,
    "subjects": subjects ?? [],
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
    "mentors": mentors == null
        ? []
        : List<dynamic>.from(mentors!.map((x) => x.toJson())),
  };
}

// ── Helper functions for safer parsing ──────────────────────────────────────

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
  }
  // Fallback: if backend sends comma-separated string
  if (value is String) {
    return value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
  return [];
}

List<Mentor> _parseMentorList(dynamic value) {
  if (value == null || value is! List) return [];
  return List<Mentor>.from(
    value.map((x) {
      if (x is Map<String, dynamic>) return Mentor.fromJson(x);
      return null;
    }).whereType<Mentor>(),
  );
}

class Mentor {
  int? id;
  String? fullName;
  String? phoneNumber;
  String? profilePic;
  String? status;
  String? mentorStatus;

  Mentor({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.profilePic,
    this.status,
    this.mentorStatus,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) => Mentor(
    id: _parseInt(json["id"]),
    fullName: json["full_name"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    profilePic: json["profile_pic"]?.toString(),
    status: json["status"]?.toString(),
    mentorStatus: json["mentor_status"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "profile_pic": profilePic,
    "status": status,
    "mentor_status": mentorStatus,
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
    fullName: json["full_name"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    profilePic: json["profile_pic"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "phone_number": phoneNumber,
    "profile_pic": profilePic,
  };
}

// ── Enums (kept as original) ────────────────────────────────────────────────

enum Gender { female, male }

final genderValues = {
  "female": Gender.female,
  "male": Gender.male,
};

enum Requires { partTime }

final requiresValues = {
  "Part Time": Requires.partTime,
};

enum TeachingMode { offline, online }

final teachingModeValues = {
  "offline": TeachingMode.offline,
  "online": TeachingMode.online,
};