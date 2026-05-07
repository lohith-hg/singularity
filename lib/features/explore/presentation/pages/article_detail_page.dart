import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/article_entity.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          article.heading,
          style: TextStyle(fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        ),
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
          children: [
            Image.asset(article.imgUrl[0]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image Credits : ${article.imgCredits}',
                style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 14,
                    fontFamily: GoogleFonts.titilliumWeb().fontFamily),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(article.heading,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Text(article.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: article.paragraphs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final para = article.paragraphs[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(para.heading,
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                                fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                        if (para.imgUrl != null) Image.asset(para.imgUrl!),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(para.description,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
