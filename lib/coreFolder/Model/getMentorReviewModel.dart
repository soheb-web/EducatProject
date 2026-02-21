// To parse this JSON data, do
//
//     final getmentorReviewModel = getmentorReviewModelFromJson(jsonString);

import 'dart:convert';

GetmentorReviewModel getmentorReviewModelFromJson(String str) =>
    GetmentorReviewModel.fromJson(json.decode(str));

String getmentorReviewModelToJson(GetmentorReviewModel data) =>
    json.encode(data.toJson());

class GetmentorReviewModel {
  bool? status;
  String? mentorId;
  double? averageRating;
  int? reviewsCount;
  List<Review>? reviews;

  GetmentorReviewModel({
    this.status,
    this.mentorId,
    this.averageRating,
    this.reviewsCount,
    this.reviews,
  });

  factory GetmentorReviewModel.fromJson(Map<String, dynamic> json) =>
      GetmentorReviewModel(
        status: json["status"],
        mentorId: json["mentor_id"],
        // averageRating: json["average_rating"],
        averageRating: (json["average_rating"] is int)
            ? (json["average_rating"] as int).toDouble()
            : (json["average_rating"] as double?),
        reviewsCount: json["reviews_count"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "mentor_id": mentorId,
        "average_rating": averageRating,
        "reviews_count": reviewsCount,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Review {
  int? id;
  int? userId;
  String? userName;
  int? mentorId;
  String? mentorName;
  String? description;
  int? rating;
  DateTime? createdAt;

  Review({
    this.id,
    this.userId,
    this.userName,
    this.mentorId,
    this.mentorName,
    this.description,
    this.rating,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        userName: json["user_name"],
        mentorId: json["mentor_id"],
        mentorName: json["mentor_name"],
        description: json["description"],
        rating: json["rating"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user_name": userName,
        "mentor_id": mentorId,
        "mentor_name": mentorName,
        "description": description,
        "rating": rating,
        "created_at": createdAt?.toIso8601String(),
      };
}
