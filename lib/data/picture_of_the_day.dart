// To parse this JSON data, do
//
//     final pictureOfTheDay = pictureOfTheDayFromJson(jsonString);

import 'dart:convert';

List<PictureOfTheDay> pictureOfTheDayFromJson(String str) => List<PictureOfTheDay>.from(json.decode(str).map((x) => PictureOfTheDay.fromJson(x)));

String pictureOfTheDayToJson(List<PictureOfTheDay> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PictureOfTheDay {
    PictureOfTheDay({
        required this.copyright,
        required this.date,
        required this.explanation,
        required this.hdurl,
        required this.mediaType,
        required this.serviceVersion,
        required this.title,
        required this.url,
    });

    String copyright;
    DateTime date;
    String explanation;
    String hdurl;
    String mediaType;
    String serviceVersion;
    String title;
    String url;

    factory PictureOfTheDay.fromJson(Map<String, dynamic> json) => PictureOfTheDay(
        copyright: json["copyright"] == null ? "NASA" : json["copyright"],
        date: DateTime.parse(json["date"]),
        explanation: json["explanation"],
        hdurl: json["hdurl"] == null ? "NASA" : json["hdurl"],
        mediaType: json["media_type"],
        serviceVersion: json["service_version"],
        title: json["title"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "copyright": copyright == null ? null : copyright,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "explanation": explanation,
        "hdurl": hdurl == null ? null : hdurl,
        "media_type": mediaType,
        "service_version": serviceVersion,
        "title": title,
        "url": url,
    };
}
