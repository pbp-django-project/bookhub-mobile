// To parse this JSON data, do
//
//     final books = booksFromJson(jsonString);

import 'dart:convert';

List<Books> booksFromJson(String str) => List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books{
    String model;
    int pk;
    Fields fields;

    Books({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
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
    String title;
    String authors;
    String publisher;
    int pubYear;
    String isbn;
    String coverImg;

    Fields({
        required this.title,
        required this.authors,
        required this.publisher,
        required this.pubYear,
        required this.isbn,
        required this.coverImg,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        authors: json["authors"],
        publisher: json["publisher"],
        pubYear: json["pub_year"],
        isbn: json["isbn"],
        coverImg: json["cover_img"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "authors": authors,
        "publisher": publisher,
        "pub_year": pubYear,
        "isbn": isbn,
        "cover_img": coverImg,
    };
}
