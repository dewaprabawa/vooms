class TutorEntity {
  String id;
  String email;
  String fullname;
  String phone;
  String photoUrl;
  Role role;
  String displayName;
  String address;
  TutorDetails tutorDetails;

  TutorEntity({
    required this.id,
    required this.email,
    required this.fullname,
    required this.phone,
    required this.photoUrl,
    required this.role,
    required this.displayName,
    required this.tutorDetails,
    required this.address,
  });

  factory TutorEntity.fromJson(Map<String, dynamic> json) {
    return TutorEntity(
      address: json["address"] as String,
      id: json['id'] as String,
      email: json['email'] as String,
      fullname: json['fullname'] as String,
      phone: json['phone'] as String,
      photoUrl: json['photoUrl'] as String,
      role: json['role'] != null
          ? Role.fromJson(json['role'])
          : Role(roleName: "", materialCompletion: false),
      displayName: json['displayName'] as String,
      tutorDetails:
          TutorDetails.fromJson(json['tutor_detail'] as Map<String, dynamic>),
    );
  }
}

class Role {
  final String roleName;
  final bool materialCompletion;

  Role({required this.roleName, required this.materialCompletion});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      materialCompletion: json["material_completion"],
      roleName: json["role_name"],
    );
  }
}

class TutorDetails {
  List<CourseDetail> courseDetailList;
  List<String> courseList;
  Popularity popularity;
  List<Review> reviewList;
  String teacherOverview;
  Wages wages;

  TutorDetails({
    required this.courseDetailList,
    required this.courseList,
    required this.popularity,
    required this.reviewList,
    required this.teacherOverview,
    required this.wages,
  });

  factory TutorDetails.fromJson(Map<String, dynamic> json) {
    List<CourseDetail> courseDetails = [];
    List<Review> reviewList = [];

    if (json['course_detail'] != null) {
      json['course_detail'].forEach((courseDetail) {
        courseDetails.add(CourseDetail.fromJson(courseDetail));
      });
    }

    if (json['reviews'] != null) {
      json['reviews'].forEach((review) {
        reviewList.add(Review.fromJson(review));
      });
    }

    return TutorDetails(
      courseDetailList: courseDetails,
      courseList: List<String>.from(json['course_list']),
      popularity: Popularity.fromJson(json['popularity']),
      reviewList: reviewList,
      teacherOverview: json['teacher_overview'],
      wages: json['wages'] != null
          ? Wages.fromJson(json['wages'])
          : Wages.fromJson({}),
    );
  }
}

class CourseDetail {
  int coursePrice;
  String imageUrl;
  String overview;
  String subjectId;
  String subjectName;

  CourseDetail({
    required this.coursePrice,
    required this.imageUrl,
    required this.overview,
    required this.subjectId,
    required this.subjectName,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      coursePrice: json['course_price'] == null ? 0 : json['course_price'] as int,
      imageUrl: json['image_url'] == null ? "" : json['image_url'] as String,
      overview: json["overview"] == null ? "" : json['overview'] as String,
      subjectId: json["subject_id"] == null ? "" : json['subject_id'] as String,
      subjectName:
          json["subject_name"] == null ? "" : json['subject_name'] as String,
    );
  }
}

class Popularity {
  int like;
  double rating;

  Popularity({
    required this.like,
    required this.rating,
  });

  factory Popularity.fromJson(Map<String, dynamic> json) {
    return Popularity(
      like: json['like'] != null ? int.parse(json['like']) : 0,
      rating: json['rating'] != null ? double.parse(json['rating']) : 0,
    );
  }
}

class Review {
  String reviewComment;
  String reviewerId;
  double reviewerRate;

  Review({
    required this.reviewComment,
    required this.reviewerId,
    required this.reviewerRate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewComment: json['review_comment'] ?? '',
      reviewerId: json['reviewer_id'] ?? '',
      reviewerRate: json['reviewer_rate'] != null
          ? double.parse(json['reviewer_rate'])
          : 0.0,
    );
  }
}

class Wages {
  String frequency;
  double amount;

  Wages({
    required this.frequency,
    required this.amount,
  });

  factory Wages.fromJson(Map<String, dynamic> json) {
    return Wages(
      frequency: json['frequency'],
      amount: json['amount'] != null ? double.parse(json['amount']) : 0.0,
    );
  }
}
