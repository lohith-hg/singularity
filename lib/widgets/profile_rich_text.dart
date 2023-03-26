import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class ProfileRichText extends StatelessWidget {
  final String title;
  final String text;

  const ProfileRichText({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          fontSize: 16,
          color: secondaryColor,
          fontFamily: GoogleFonts.titilliumWeb().fontFamily,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: GoogleFonts.titilliumWeb().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
