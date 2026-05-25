import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

enum SButtonVariant { primary, ghost, icon }

class SButton extends StatelessWidget {
  const SButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SButtonVariant.primary,
    this.icon,
    this.trailing,
  });

  const SButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
  }) : variant = SButtonVariant.ghost;

  const SButton.icon({
    super.key,
    required Widget child,
    required this.onPressed,
  }) : label = '',
       variant = SButtonVariant.icon,
       icon = child,
       trailing = null;

  final String label;
  final VoidCallback? onPressed;
  final SButtonVariant variant;
  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (variant == SButtonVariant.icon) {
      return SizedBox(
        width: 44,
        height: 44,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadii.pillBr,
            child: Center(child: icon),
          ),
        ),
      );
    }

    final isPrimary = variant == SButtonVariant.primary;

    return SizedBox(
      height: 48,
      child: Material(
        color: isPrimary ? AppColors.bone : Colors.transparent,
        borderRadius: AppRadii.pillBr,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadii.pillBr,
          child: Container(
            decoration: isPrimary
                ? null
                : BoxDecoration(
                    border: Border.all(color: AppColors.hairlineStrong),
                    borderRadius: AppRadii.pillBr,
                  ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isPrimary ? AppColors.ink : AppColors.bone,
                    letterSpacing: 0.1,
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
