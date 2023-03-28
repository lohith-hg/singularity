import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputText extends StatelessWidget {
  const InputText({
    Key? key,
    required this.w,
    required this.controller,
    required this.label,
    required this.hintText,
    this.inp = const [],
    this.enabled = true,
    this.showHint = false,
    this.height = 45,
    this.validator,
    this.maxLines = 1,
    this.charLimit,
    this.obscureText = false,
    this.isIcon = false,
    this.textInputType = TextInputType.emailAddress,
    this.onTap,
    this.ontapPasswordView,
    this.hasLeftPadding = false,
    this.fillColor = Colors.black,
    this.textColor = Colors.black,
  }) : super(key: key);

  final double? w;
  final TextEditingController controller;
  final TextInputType textInputType;
  final List<TextInputFormatter> inp;
  final String label;
  final String hintText;
  final bool enabled;
  final bool showHint;
  final bool obscureText;
  final double height;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? charLimit;
  final bool isIcon;
  final void Function()? onTap;
  final void Function()? ontapPasswordView;
  final bool hasLeftPadding;
  final Color fillColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 2, bottom: 2, left: hasLeftPadding ? 25 : 0),
      child: SizedBox(
        width: w,
        child: TextFormField(
          maxLines: maxLines,
          controller: controller,
          inputFormatters: inp,
          validator: validator,
          obscureText: obscureText,
          onTap: onTap,
          enabled: enabled,
          keyboardType: textInputType,
          style: TextStyle(
            color: const Color(0xff1C2B2F),
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          ),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            label: (!showHint)
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: label,
                          style: testStyle(),
                        ),
                      ],
                    ),
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            alignLabelWithHint: false,
            suffixIcon: isIcon
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: ontapPasswordView,
                  )
                : null,
            hintText: (showHint) ? hintText : null,
            hintStyle: TextStyle(
              color: const Color(0xff6F6F6F),
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontFamily: GoogleFonts.sourceSansPro().fontFamily,
            ),
            fillColor: fillColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: fillColor),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: fillColor),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: fillColor),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle testStyle() {
    return TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
    );
  }
}
