class ReivewCategoryResModel {
  bool? status;
  String? message;
  CollegeInfo? collegeInfo;
  List<Reviews>? reviews;
  String? averageRating;
  int? totalReviews;

  ReivewCategoryResModel(
      {this.status,
      this.message,
      this.collegeInfo,
      this.reviews,
      this.averageRating,
      this.totalReviews});

  ReivewCategoryResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    collegeInfo = json['college_info'] != null
        ? new CollegeInfo.fromJson(json['college_info'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    averageRating = json['average_rating'];
    totalReviews = json['totalReviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.collegeInfo != null) {
      data['college_info'] = this.collegeInfo!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['average_rating'] = this.averageRating;
    data['totalReviews'] = this.totalReviews;
    return data;
  }
}

class CollegeInfo {
  int? id;
  int? userId;
  int? count;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? collageId;
  Null? skillsId;
  String? status;
  String? type;
  String? collageName;
  String? city;
  String? image;
  String? fullName;

  CollegeInfo(
      {this.id,
      this.userId,
      this.count,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.collageId,
      this.skillsId,
      this.status,
      this.type,
      this.collageName,
      this.city,
      this.image,
      this.fullName});

  CollegeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    count = json['count'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    collageId = json['collage_id'];
    skillsId = json['skills_id'];
    status = json['status'];
    type = json['type'];
    collageName = json['collage_name'];
    city = json['city'];
    image = json['image'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['count'] = this.count;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['collage_id'] = this.collageId;
    data['skills_id'] = this.skillsId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['collage_name'] = this.collageName;
    data['city'] = this.city;
    data['image'] = this.image;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Reviews {
  int? id;
  int? userId;
  int? count;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? collageId;
  String? skillsId;
  String? status;
  String? type;
  String? collageName;
  String? city;
  String? image;
  String? fullName;

  Reviews(
      {this.id,
      this.userId,
      this.count,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.collageId,
      this.skillsId,
      this.status,
      this.type,
      this.collageName,
      this.city,
      this.image,
      this.fullName});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    count = json['count'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    collageId = json['collage_id'];
    skillsId = json['skills_id'];
    status = json['status'];
    type = json['type'];
    collageName = json['collage_name'];
    city = json['city'];
    image = json['image'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['count'] = this.count;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['collage_id'] = this.collageId;
    data['skills_id'] = this.skillsId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['collage_name'] = this.collageName;
    data['city'] = this.city;
    data['image'] = this.image;
    data['full_name'] = this.fullName;
    return data;
  }
}