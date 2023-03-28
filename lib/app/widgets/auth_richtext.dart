import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class AuthRichText extends StatelessWidget {
  String normalText;
  String richText;
  void Function()? ontap;
  AuthRichText(
      {Key? key,
      required this.normalText,
      required this.richText,
      required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: normalText,
        style:  TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontFamily: GoogleFonts.titilliumWeb().fontFamily
        ),
        children: [
          TextSpan(
            text: richText,
            recognizer: TapGestureRecognizer()..onTap = ontap,
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: GoogleFonts.titilliumWeb().fontFamily
            ),
          ),
        ],
      ),
    );
  }
}
