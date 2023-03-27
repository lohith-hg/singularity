import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: richText,
            recognizer: TapGestureRecognizer()..onTap = ontap,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
