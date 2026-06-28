import 'dart:ui';
import 'package:flutter/material.dart';

class SRoundBtn extends StatelessWidget {
  const SRoundBtn({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = 36,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: const Color(0x8C0A0A0F),
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
