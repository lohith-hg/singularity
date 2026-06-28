import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SingularityMark extends StatelessWidget {
  const SingularityMark({super.key, this.size = 32, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.bone;
    return CustomPaint(
      size: Size(size, size),
      painter: _MarkPainter(color: c),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.031;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final cy = size.height * 0.5;

    // Outer ring
    canvas.drawCircle(Offset(cx, cy), size.width * 0.453, stroke);
    // Photon sphere (50% opacity)
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.297,
      Paint()
        ..color = color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.031,
    );
    // Singularity core
    canvas.drawCircle(Offset(cx, cy), size.width * 0.094, fill);
    // Orbiting satellite dot
    final satX = cx + size.width * 0.375;
    final satY = cy - size.height * 0.219;
    canvas.drawCircle(Offset(satX, satY), size.width * 0.038, fill);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}

class SingularityWordmark extends StatelessWidget {
  const SingularityWordmark({
    super.key,
    this.size = 18,
    this.color,
    this.showMark = true,
  });

  final double size;
  final Color? color;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.bone;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showMark) ...[
          SingularityMark(size: size * 1.4, color: c),
          SizedBox(width: size * 0.5),
        ],
        Text(
          'Singularity',
          style: GoogleFonts.newsreader(
            fontSize: size,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: c,
            height: 1,
          ),
        ),
      ],
    );
  }
}
