class Article {
  String id;
  String heading;
  String discription;
  List<String> imgUrl;
  List<String> imgCredits;
  List<Paragraph> paragraphs;

  Article(
      {required this.id,
      required this.heading,
      required this.discription,
      required this.imgUrl,
      required this.imgCredits,
      required this.paragraphs});
}

class Paragraph {
  String id;
  String heading;
  String? imgUrl;
  String discription;
  Paragraph(
      {required this.id,
      required this.heading,
      this.imgUrl,
      required this.discription});
}
