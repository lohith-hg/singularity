import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

class STile extends StatelessWidget {
  const STile({
    super.key,
    required this.child,
    this.onTap,
    this.height,
    this.padding,
    this.color = AppColors.ink1,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadii.mdBr,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdBr,
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: AppRadii.mdBr,
            border: Border.all(color: AppColors.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}
