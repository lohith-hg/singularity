import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatelessWidget {
  String imgUrl;
  String title;
  double heightFactor;
  CustomContainer(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.heightFactor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / heightFactor,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              //padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Image.asset(
                  imgUrl,
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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
