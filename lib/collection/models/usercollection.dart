// To parse this JSON data, do
//
//     final Collection = CollectionFromJson(jsonString);

import 'dart:convert';

List<Collection> CollectionFromJson(String str) => List<Collection>.from(json.decode(str).map((x) => Collection.fromJson(x)));

String CollectionToJson(List<Collection> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Collection {
    String model;
    int pk;
    Fields fields;

    Collection({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Collection.fromJson(Map<String, dynamic> json) => Collection(
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
    int user;
    String title;
    String authors;
    String publisher;
    int pubYear;
    String isbn;
    String coverImg;
    DateTime dateAdded;

    Fields({
        required this.user,
        required this.title,
        required this.authors,
        required this.publisher,
        required this.pubYear,
        required this.isbn,
        required this.coverImg,
        required this.dateAdded,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        authors: json["authors"],
        publisher: json["publisher"],
        pubYear: json["pub_year"],
        isbn: json["isbn"],
        coverImg: json["cover_img"],
        dateAdded: DateTime.parse(json["date_added"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "authors": authors,
        "publisher": publisher,
        "pub_year": pubYear,
        "isbn": isbn,
        "cover_img": coverImg,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
    };
}