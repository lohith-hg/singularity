// To parse this JSON data, do
//
//     final marsPictures = marsPicturesFromJson(jsonString);

import 'dart:convert';

MarsPictures marsPicturesFromJson(String str) => MarsPictures.fromJson(json.decode(str));

String marsPicturesToJson(MarsPictures data) => json.encode(data.toJson());

class MarsPictures {
    MarsPictures({
        required this.photos,
    });

    List<Photo> photos;

    factory MarsPictures.fromJson(Map<String, dynamic> json) => MarsPictures(
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    };
}

class Photo {
    Photo({
        required this.id,
        required this.sol,
        required this.camera,
        required this.imgSrc,
        required this.earthDate,
        required this.rover,
    });

    int id;
    int sol;
    Camera camera;
    String imgSrc;
    DateTime earthDate;
    Rover rover;

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        sol: json["sol"],
        camera: Camera.fromJson(json["camera"]),
        imgSrc: json["img_src"],
        earthDate: DateTime.parse(json["earth_date"]),
        rover: Rover.fromJson(json["rover"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sol": sol,
        "camera": camera.toJson(),
        "img_src": imgSrc,
        "earth_date": "${earthDate.year.toString().padLeft(4, '0')}-${earthDate.month.toString().padLeft(2, '0')}-${earthDate.day.toString().padLeft(2, '0')}",
        "rover": rover.toJson(),
    };
}

class Camera {
    Camera({
        required this.id,
        required this.name,
        required this.roverId,
        required this.fullName,
    });

    int id;
    String name;
    int roverId;
    String fullName;

    factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        id: json["id"],
        name: json["name"],
        roverId: json["rover_id"],
        fullName: json["full_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rover_id": roverId,
        "full_name": fullName,
    };
}

class Rover {
    Rover({
        required this.id,
        required this.name,
        required this.landingDate,
        required this.launchDate,
        required this.status,
    });

    int id;
    String name;
    DateTime landingDate;
    DateTime launchDate;
    String status;

    factory Rover.fromJson(Map<String, dynamic> json) => Rover(
        id: json["id"],
        name: json["name"],
        landingDate: DateTime.parse(json["landing_date"]),
        launchDate: DateTime.parse(json["launch_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "landing_date": "${landingDate.year.toString().padLeft(4, '0')}-${landingDate.month.toString().padLeft(2, '0')}-${landingDate.day.toString().padLeft(2, '0')}",
        "launch_date": "${launchDate.year.toString().padLeft(4, '0')}-${launchDate.month.toString().padLeft(2, '0')}-${launchDate.day.toString().padLeft(2, '0')}",
        "status": status,
    };
}
