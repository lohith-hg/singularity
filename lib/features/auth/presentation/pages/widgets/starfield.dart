import 'dart:math';
import 'package:flutter/material.dart';

class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key, this.opacity = 1.0});

  final double opacity;

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => CustomPaint(
          painter: _StarfieldPainter(_ctrl.value),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter(this.t);
  final double t;

  static final _stars = List.generate(120, (i) {
    final rng = Random(i * 7919);
    return _Star(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      r: rng.nextDouble() * 1.2 + 0.3,
      opacity: rng.nextDouble() * 0.6 + 0.2,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final angle = t * 2 * pi;

    for (final s in _stars) {
      final x = s.x * size.width;
      final y = s.y * size.height;

      // Slow parallax drift
      final dx =
          (x - cx) * cos(angle * 0.01) - (y - cy) * sin(angle * 0.01) + cx - x;
      final dy =
          (x - cx) * sin(angle * 0.01) + (y - cy) * cos(angle * 0.01) + cy - y;

      final px = (x + dx * 0.02) % size.width;
      final py = (y + dy * 0.02) % size.height;

      canvas.drawCircle(
        Offset(px, py),
        s.r,
        Paint()..color = Color.fromRGBO(244, 242, 238, s.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}

class _Star {
  const _Star({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
  });
  final double x, y, r, opacity;
}
