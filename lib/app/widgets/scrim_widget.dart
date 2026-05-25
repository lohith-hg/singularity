import 'package:flutter/material.dart';

class BottomScrim extends StatelessWidget {
  const BottomScrim({super.key, this.heightFraction = 0.6});

  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: heightFraction,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xCC050507),
                  Color(0xFF0A0A0F),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopScrim extends StatelessWidget {
  const TopScrim({super.key, this.heightFraction = 0.3});

  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          heightFactor: heightFraction,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xB3050507), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
