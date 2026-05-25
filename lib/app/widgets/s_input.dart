import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SInput extends StatefulWidget {
  const SInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<SInput> createState() => _SInputState();
}

class _SInputState extends State<SInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: AppColors.bone3,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          autofillHints: widget.autofillHints,
          style: const TextStyle(
            fontFamily: 'Geist',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.bone,
          ),
          cursorColor: AppColors.bone,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontFamily: 'Geist',
              fontSize: 17,
              color: AppColors.bone4,
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.hairlineStrong),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.hairlineStrong),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.bone, width: 1.5),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger),
            ),
            contentPadding: const EdgeInsets.only(bottom: 12, top: 8),
            filled: false,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.bone3,
                      size: 18,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
