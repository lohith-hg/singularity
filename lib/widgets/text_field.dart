import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  const InputText(
      {Key? key,
      required this.controller,
      required this.label,
      required this.hintText,
      this.inp = const [],
      this.validator,
      this.enabled = true,
      this.color = Colors.black,
      this.maxLines = 1})
      : super(key: key);

  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter> inp;
  final String hintText;
  final dynamic validator;
  final int maxLines;
  final Color color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      maxLines: maxLines,
      controller: controller,
      inputFormatters: inp,
      validator: validator,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      style: testStyle(),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: testStyle(),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        alignLabelWithHint: false,
        //hintText: hintText,
        errorMaxLines: 2,
        hintStyle: testStyle(),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: color),
        ),
        fillColor: Colors.black.withOpacity(0.6),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: color,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: color),
        ),
        errorStyle: const TextStyle(
          fontSize: 18.0,
          fontFamily: 'dity',
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  TextStyle testStyle() {
    return const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'dity');
  }
}
