// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int book;
    int user;
    String title;
    int rating;
    String comment;
    String username;

    Fields({
        required this.book,
        required this.user,
        required this.title,
        required this.rating,
        required this.comment,
        required this.username,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        user: json["user"],
        title: json["title"],
        rating: json["rating"],
        comment: json["comment"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "user": user,
        "title": title,
        "rating": rating,
        "comment": comment,
        "username": username,
    };
}
