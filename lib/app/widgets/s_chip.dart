import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

class SChip extends StatelessWidget {
  const SChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.bone : Colors.transparent,
          borderRadius: AppRadii.pillBr,
          border: Border.all(
            color: selected ? AppColors.bone : AppColors.hairlineStrong,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: selected ? AppColors.ink : AppColors.bone2,
            height: 1,
          ),
        ),
      ),
    );
  }
}
