/*

import 'dart:convert';

ReviewGetModel reviewGetModelFromJson(String str) => ReviewGetModel.fromJson(json.decode(str));

String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

class ReviewGetModel {
  bool? status;
  Collage? collage;
  List<Review>? reviews;

  ReviewGetModel({
    this.status,
    this.collage,
    this.reviews,
  });

  factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
    status: json["status"],
    collage: json["collage"] == null ? null : Collage.fromJson(json["collage"]),
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "collage": collage?.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Collage {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  int? rating;
  int? totalReviews;
  Map<String, int>? distribution;
  int? totalUsers;
  List<User>? users;

  Collage({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.rating,
    this.totalReviews,
    this.distribution,
    this.totalUsers,
    this.users,
  });

  factory Collage.fromJson(Map<String, dynamic> json) => Collage(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    phone: json["phone"],
    email: json["email"],
    website: json["website"],
    image: json["image"],
    city: json["city"],
    pincode: json["pincode"],
    type: json["type"],
    rating: json["rating"],
    totalReviews: json["total_reviews"],
    distribution: Map.from(json["distribution"]!).map((k, v) => MapEntry<String, int>(k, v)),
    totalUsers: json["total_users"],
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "phone": phone,
    "email": email,
    "website": website,
    "image": image,
    "city": city,
    "pincode": pincode,
    "type": type,
    "rating": rating,
    "total_reviews": totalReviews,
    "distribution": Map.from(distribution!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "total_users": totalUsers,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  int? id;
  String? fullName;
  String? email;
  String? userType;
  int? collegeId;
  dynamic companyId;
  String? profilePic;

  User({
    this.id,
    this.fullName,
    this.email,
    this.userType,
    this.collegeId,
    this.companyId,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    userType: json["user_type"],
    collegeId: json["college_id"],
    companyId: json["company_id"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "user_type": userType,
    "college_id": collegeId,
    "company_id": companyId,
    "profile_pic": profilePic,
  };
}

class Review {
  int? userId;
  String? fullName;
  int? rating;
  String? description;
  String? title;
  NameWiseRating? nameWiseRating;
  List<dynamic>? skills;
  DateTime? createdAt;

  Review({
    this.userId,
    this.fullName,
    this.rating,
    this.description,
    this.title,
    this.nameWiseRating,
    this.skills,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    userId: json["user_id"],
    fullName: json["full_name"],
    rating: json["rating"],
    description: json["description"],
    title: json["title"],
    nameWiseRating: json["name_wise_rating"] == null ? null : NameWiseRating.fromJson(json["name_wise_rating"]),
    skills: json["skills"] == null ? [] : List<dynamic>.from(json["skills"]!.map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "rating": rating,
    "description": description,
    "title": title,
    "name_wise_rating": nameWiseRating?.toJson(),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
  };
}

class NameWiseRating {
  String? description;
  String? averageRating;
  int? totalReviews;
  List<Reviewer>? reviewers;

  NameWiseRating({
    this.description,
    this.averageRating,
    this.totalReviews,
    this.reviewers,
  });

  factory NameWiseRating.fromJson(Map<String, dynamic> json) => NameWiseRating(
    description: json["description"],
    averageRating: json["average_rating"],
    totalReviews: json["total_reviews"],
    reviewers: json["reviewers"] == null ? [] : List<Reviewer>.from(json["reviewers"]!.map((x) => Reviewer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "average_rating": averageRating,
    "total_reviews": totalReviews,
    "reviewers": reviewers == null ? [] : List<dynamic>.from(reviewers!.map((x) => x.toJson())),
  };
}

class Reviewer {
  String? reviewerName;
  int? reviewerCount;

  Reviewer({
    this.reviewerName,
    this.reviewerCount,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    reviewerName: json["reviewer_name"],
    reviewerCount: json["reviewer_count"],
  );

  Map<String, dynamic> toJson() => {
    "reviewer_name": reviewerName,
    "reviewer_count": reviewerCount,
  };
}
*/

// To parse this JSON data, do
//
//     final reviewGetModel = reviewGetModelFromJson(jsonString);
/*

import 'dart:convert';

ReviewGetModel reviewGetModelFromJson(String str) => ReviewGetModel.fromJson(json.decode(str));

String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

class ReviewGetModel {
  bool? status;
  Collage? collage;
  List<Review>? reviews;

  ReviewGetModel({
    this.status,
    this.collage,
    this.reviews,
  });

  factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
    status: json["status"],
    collage: json["collage"] == null ? null : Collage.fromJson(json["collage"]),
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "collage": collage?.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Collage {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  double? rating;
  int? totalReviews;
  Map<String, int>? distribution;
  int? totalUsers;
  List<User>? users;

  Collage({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.rating,
    this.totalReviews,
    this.distribution,
    this.totalUsers,
    this.users,
  });

  factory Collage.fromJson(Map<String, dynamic> json) => Collage(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    phone: json["phone"],
    email: json["email"],
    website: json["website"],
    image: json["image"],
    city: json["city"],
    pincode: json["pincode"],
    type: json["type"],
    rating: json["rating"]?.toDouble(),
    totalReviews: json["total_reviews"],
    distribution: Map.from(json["distribution"]!).map((k, v) => MapEntry<String, int>(k, v)),
    totalUsers: json["total_users"],
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "phone": phone,
    "email": email,
    "website": website,
    "image": image,
    "city": city,
    "pincode": pincode,
    "type": type,
    "rating": rating,
    "total_reviews": totalReviews,
    "distribution": Map.from(distribution!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "total_users": totalUsers,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  int? id;
  String? fullName;
  String? email;
  String? userType;
  int? collegeId;
  dynamic companyId;
  String? profilePic;

  User({
    this.id,
    this.fullName,
    this.email,
    this.userType,
    this.collegeId,
    this.companyId,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    userType: json["user_type"],
    collegeId: json["college_id"],
    companyId: json["company_id"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "user_type": userType,
    "college_id": collegeId,
    "company_id": companyId,
    "profile_pic": profilePic,
  };
}

class Review {
  int? userId;
  String? fullName;
  int? rating;
  String? description;
  String? title;
  NameWiseRating? nameWiseRating;
  List<dynamic>? skills;
  DateTime? createdAt;

  Review({
    this.userId,
    this.fullName,
    this.rating,
    this.description,
    this.title,
    this.nameWiseRating,
    this.skills,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    userId: json["user_id"],
    fullName: json["full_name"],
    rating: json["rating"],
    description: json["description"],
    title: json["title"],
    nameWiseRating: json["name_wise_rating"] == null ? null : NameWiseRating.fromJson(json["name_wise_rating"]),
    skills: json["skills"] == null ? [] : List<dynamic>.from(json["skills"]!.map((x) => x)),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "rating": rating,
    "description": description,
    "title": title,
    "name_wise_rating": nameWiseRating?.toJson(),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
  };
}

class NameWiseRating {
  String? description;
  String? averageRating;
  int? totalReviews;
  List<Reviewer>? reviewers;

  NameWiseRating({
    this.description,
    this.averageRating,
    this.totalReviews,
    this.reviewers,
  });

  factory NameWiseRating.fromJson(Map<String, dynamic> json) => NameWiseRating(
    description: json["description"],
    averageRating: json["average_rating"],
    totalReviews: json["total_reviews"],
    reviewers: json["reviewers"] == null ? [] : List<Reviewer>.from(json["reviewers"]!.map((x) => Reviewer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "average_rating": averageRating,
    "total_reviews": totalReviews,
    "reviewers": reviewers == null ? [] : List<dynamic>.from(reviewers!.map((x) => x.toJson())),
  };
}

class Reviewer {
  String? reviewerName;
  int? reviewerCount;

  Reviewer({
    this.reviewerName,
    this.reviewerCount,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    reviewerName: json["reviewer_name"],
    reviewerCount: json["reviewer_count"],
  );

  Map<String, dynamic> toJson() => {
    "reviewer_name": reviewerName,
    "reviewer_count": reviewerCount,
  };
}
*/

// To parse this JSON data, do
//
//     final reviewGetModel = reviewGetModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final reviewGetModel = reviewGetModelFromJson(jsonString);

import 'dart:convert';

ReviewGetModel reviewGetModelFromJson(String str) =>
    ReviewGetModel.fromJson(json.decode(str));

String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

class ReviewGetModel {
  bool? status;
  Collage? collage;
  List<Review>? reviews;

  ReviewGetModel({
    this.status,
    this.collage,
    this.reviews,
  });

  factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
        status: json["status"],
        collage:
            json["collage"] == null ? null : Collage.fromJson(json["collage"]),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "collage": collage?.toJson(),
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Collage {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  int? rating;
  int? totalReviews;
  Map<String, int>? distribution;
  int? totalUsers;
  List<User>? users;
  int? totalFollowers;
  List<Follower>? followers;
  String? isFollowed;

  Collage({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.rating,
    this.totalReviews,
    this.distribution,
    this.totalUsers,
    this.users,
    this.totalFollowers,
    this.followers,
    this.isFollowed,
  });

  factory Collage.fromJson(Map<String, dynamic> json) => Collage(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        email: json["email"],
        website: json["website"],
        image: json["image"],
        city: json["city"],
        pincode: json["pincode"],
        type: json["type"],
        // rating: json["rating"],
        rating: json["rating"] == null ? null : (json["rating"] as num).toInt(),
        totalReviews: json["total_reviews"],
        distribution: Map.from(json["distribution"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        totalUsers: json["total_users"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        totalFollowers: json["totalFollowers"],
        followers: json["followers"] == null
            ? []
            : List<Follower>.from(
                json["followers"]!.map((x) => Follower.fromJson(x))),
        isFollowed: json["is_followed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "email": email,
        "website": website,
        "image": image,
        "city": city,
        "pincode": pincode,
        "type": type,
        "rating": rating,
        "total_reviews": totalReviews,
        "distribution": Map.from(distribution!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "total_users": totalUsers,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "totalFollowers": totalFollowers,
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x.toJson())),
        "is_followed": isFollowed,
      };
}

class Follower {
  int? id;
  String? fullName;
  String? email;
  String? userType;
  String? profilePic;

  Follower({
    this.id,
    this.fullName,
    this.email,
    this.userType,
    this.profilePic,
  });

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        userType: json["user_type"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "user_type": userType,
        "profile_pic": profilePic,
      };
}

class User {
  int? id;
  String? fullName;
  String? email;
  String? userType;
  int? collegeId;
  dynamic companyId;
  String? profilePic;

  User({
    this.id,
    this.fullName,
    this.email,
    this.userType,
    this.collegeId,
    this.companyId,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        userType: json["user_type"],
        collegeId: json["college_id"],
        companyId: json["company_id"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "user_type": userType,
        "college_id": collegeId,
        "company_id": companyId,
        "profile_pic": profilePic,
      };
}

class Review {
  int? userId;
  String? fullName;
  int? rating;
  String? description;
  String? title;
  NameWiseRating? nameWiseRating;
  List<dynamic>? skills;
  DateTime? createdAt;

  Review({
    this.userId,
    this.fullName,
    this.rating,
    this.description,
    this.title,
    this.nameWiseRating,
    this.skills,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        fullName: json["full_name"],
        rating: json["rating"],
        description: json["description"],
        title: json["title"],
        nameWiseRating: json["name_wise_rating"] == null
            ? null
            : NameWiseRating.fromJson(json["name_wise_rating"]),
        skills: json["skills"] == null
            ? []
            : List<dynamic>.from(json["skills"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "rating": rating,
        "description": description,
        "title": title,
        "name_wise_rating": nameWiseRating?.toJson(),
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
      };
}

class NameWiseRating {
  String? description;
  String? averageRating;
  int? totalReviews;
  List<Reviewer>? reviewers;

  NameWiseRating({
    this.description,
    this.averageRating,
    this.totalReviews,
    this.reviewers,
  });

  factory NameWiseRating.fromJson(Map<String, dynamic> json) => NameWiseRating(
        description: json["description"],
        averageRating: json["average_rating"],
        totalReviews: json["total_reviews"],
        reviewers: json["reviewers"] == null
            ? []
            : List<Reviewer>.from(
                json["reviewers"]!.map((x) => Reviewer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "average_rating": averageRating,
        "total_reviews": totalReviews,
        "reviewers": reviewers == null
            ? []
            : List<dynamic>.from(reviewers!.map((x) => x.toJson())),
      };
}

class Reviewer {
  String? reviewerName;
  int? reviewerCount;

  Reviewer({
    this.reviewerName,
    this.reviewerCount,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
        reviewerName: json["reviewer_name"],
        reviewerCount: json["reviewer_count"],
      );

  Map<String, dynamic> toJson() => {
        "reviewer_name": reviewerName,
        "reviewer_count": reviewerCount,
      };
}
