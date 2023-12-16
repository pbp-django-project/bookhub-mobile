// To parse this JSON data, do
//
//     final bulletin = bulletinFromJson(jsonString);

import 'dart:convert';

List<Bulletin> bulletinFromJson(String str) => List<Bulletin>.from(json.decode(str).map((x) => Bulletin.fromJson(x)));

String bulletinToJson(List<Bulletin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bulletin {
    Model model;
    int pk;
    Fields fields;

    Bulletin({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Bulletin.fromJson(Map<String, dynamic> json) => Bulletin(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String content;
    String author;
    DateTime datePublished;

    Fields({
        required this.title,
        required this.content,
        required this.author,
        required this.datePublished,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        content: json["content"],
        author: json["author"],
        datePublished: DateTime.parse(json["date_published"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "author": author,
        "date_published": datePublished.toIso8601String(),
    };
}

enum Model {
    BULLETIN_BULLETIN
}

final modelValues = EnumValues({
    "bulletin.bulletin": Model.BULLETIN_BULLETIN
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}