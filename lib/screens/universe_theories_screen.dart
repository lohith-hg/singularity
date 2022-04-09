import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/data/articles_data.dart';
import 'package:singularity/screens/article_detail_screen.dart';

class UniverseTheories extends StatefulWidget {
  const UniverseTheories({Key? key}) : super(key: key);

  @override
  State<UniverseTheories> createState() => _UniverseTheoriesState();
}

class _UniverseTheoriesState extends State<UniverseTheories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Theories of the Universe',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: universeArticles.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ArticleDetailScreen(articleIndex: index),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                //height: MediaQuery.of(context).size.height / 2.5,
                height: MediaQuery.of(context).size.height / 3.3,

                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Hero(
                          tag: (index + 3),
                          child: Image.asset(
                            universeArticles[index].imgUrl[0],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.orange
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0, 0.6, 1],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(universeArticles[index].heading,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                      fontFamily: GoogleFonts.titilliumWeb()
                                          .fontFamily)),
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
