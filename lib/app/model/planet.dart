class Planet {
  String id;
  String name;
  String credits;
  List<String> imgUrl;
  String discription;
  String lengthOfYear;
  String gravity;
  String distanceFromSun;
  String noOfMoons;
  List<Fact> facts;
  Planet(
      {required this.id,
      required this.name,
      required this.credits,
      required this.imgUrl,
      required this.discription,
      required this.lengthOfYear,
      required this.gravity,
      required this.distanceFromSun,
      required this.noOfMoons,
      required this.facts});
}

class Fact {
  String id;
  String heading;
  String discription;
  Fact({required this.id, required this.heading, required this.discription});
}
