import 'dart:convert';

CourseModel courseModelFromJson(String str) => CourseModel.fromJson(json.decode(str));

String courseModelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
    final List<Course>? courses;

    CourseModel({
        this.courses,
    });

    factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        courses: json["courses"] == null ? [] : List<Course>.from(json["courses"]!.map((x) => Course.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "courses": courses == null ? [] : List<dynamic>.from(courses!.map((x) => x.toJson())),
    };
}

class Course {
    final int? id;
    final String? title;
    final String? subTitle;
    final int? price;
    final String? banner;
    final int? discountType;
    final int? discountAmount;
    final String? discountStartDate;
    final String? discountEndDate;
    final String? altText;
    final String? bannerTitle;
    final String? durationInMonth;
    final String? totalClass;
    final int? totalExam;
    final int? totalLive;
    final String? orderStatus;

    Course({
        this.id,
        this.title,
        this.subTitle,
        this.price,
        this.banner,
        this.discountType,
        this.discountAmount,
        this.discountStartDate,
        this.discountEndDate,
        this.altText,
        this.bannerTitle,
        this.durationInMonth,
        this.totalClass,
        this.totalExam,
        this.totalLive,
        this.orderStatus,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        price: json["price"],
        banner: json["banner"],
        discountType: json["discount_type"],
        discountAmount: json["discount_amount"],
        discountStartDate: json["discount_start_date"],
        discountEndDate: json["discount_end_date"],
        altText: json["alt_text"],
        bannerTitle: json["banner_title"],
        durationInMonth: json["duration_in_month"],
        totalClass: json["total_class"],
        totalExam: json["total_exam"],
        totalLive: json["total_live"],
        orderStatus: json["order_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "price": price,
        "banner": banner,
        "discount_type": discountType,
        "discount_amount": discountAmount,
        "discount_start_date": discountStartDate,
        "discount_end_date": discountEndDate,
        "alt_text": altText,
        "banner_title": bannerTitle,
        "duration_in_month": durationInMonth,
        "total_class": totalClass,
        "total_exam": totalExam,
        "total_live": totalLive,
        "order_status": orderStatus,
    };
}
