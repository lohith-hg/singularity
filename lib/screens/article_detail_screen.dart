import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/data/article.dart';
import 'package:singularity/data/articles_data.dart';
import 'package:singularity/data/planet.dart';

class ArticleDetailScreen extends StatefulWidget {
  int articleIndex;
  ArticleDetailScreen({Key? key, required this.articleIndex}) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Article _article = universeArticles[widget.articleIndex];
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _article.heading,
          style: TextStyle(fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        ),
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
          children: [
            Image.asset(
              _article.imgUrl[0],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image Credits : ${_article.imgCredits}',
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
                child: Text(_article.heading,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Text(_article.discription,
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
                  itemCount: _article.paragraphs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_article.paragraphs[index].heading,
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                                fontFamily:
                                    GoogleFonts.titilliumWeb().fontFamily)),
                        if (_article.paragraphs[index].imgUrl != null)
                          Image.asset(_article.paragraphs[index].imgUrl!),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_article.paragraphs[index].discription,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily:
                                      GoogleFonts.titilliumWeb().fontFamily)),
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
