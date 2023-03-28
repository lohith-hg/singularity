// To parse this JSON data, do
//
//     final historyAlbum = historyAlbumFromJson(jsonString);

import 'dart:convert';

HistoryAlbum historyAlbumFromJson(String str) => HistoryAlbum.fromJson(json.decode(str));

String historyAlbumToJson(HistoryAlbum data) => json.encode(data.toJson());

class HistoryAlbum {
    HistoryAlbum({
        this.href,
        this.data,
        this.links,
    });

    String? href;
    List<Data>? data;
    List<Link>? links;

    factory HistoryAlbum.fromJson(Map<String, dynamic> json) => HistoryAlbum(
        href: json["href"],
        data: json["data"] == null ? [] : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "href": href,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        this.center,
        this.title,
        this.nasaId,
        this.dateCreated,
        this.keywords,
        this.mediaType,
        this.description508,
        this.secondaryCreator,
        this.description,
    });

    String? center;
    String? title;
    String? nasaId;
    DateTime? dateCreated;
    List<String>? keywords;
    String? mediaType;
    String? description508;
    String? secondaryCreator;
    String? description;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        center: json["center"],
        title: json["title"],
        nasaId: json["nasa_id"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        keywords: json["keywords"] == null ? [] : List<String>.from(json["keywords"]!.map((x) => x)),
        mediaType: json["media_type"],
        description508: json["description_508"],
        secondaryCreator: json["secondary_creator"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "center": center,
        "title": title,
        "nasa_id": nasaId,
        "date_created": dateCreated?.toIso8601String(),
        "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
        "media_type": mediaType,
        "description_508": description508,
        "secondary_creator": secondaryCreator,
        "description": description,
    };
}

class Link {
    Link({
        this.href,
        this.rel,
        this.render,
    });

    String? href;
    String? rel;
    String? render;

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        href: json["href"],
        rel: json["rel"],
        render: json["render"],
    );

    Map<String, dynamic> toJson() => {
        "href": href,
        "rel": rel,
        "render": render,
    };
}
