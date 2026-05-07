import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/widgets/custom_dialog.dart';
import '../../domain/entities/article_entity.dart';
import 'universe_theories_page.dart';

class TheoriesPage extends StatelessWidget {
  final List<ArticleEntity> articles;

  const TheoriesPage({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCard(
            context,
            imagePath: 'assets/polar-lights-5858656_1920.jpg',
            title: 'Theories of the Universe',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UniverseTheoriesPage(articles: articles),
            )),
          ),
          _buildCard(
            context,
            imagePath: 'assets/area-2494124_1920.jpg',
            title: 'Space Conspiracy Theories',
            onTap: () => showDialog(
              context: context,
              builder: (context) => CustomDialog(
                displayText: 'Space Conspiracy Theories Coming soon',
                buttonText: 'OK',
                buttonWidth: 0.4,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Image.asset(imagePath, fit: BoxFit.fill),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              fontFamily:
                                  GoogleFonts.titilliumWeb().fontFamily)),
                    ),
                    const SizedBox(height: 3.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
