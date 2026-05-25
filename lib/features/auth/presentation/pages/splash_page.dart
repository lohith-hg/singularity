import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../app/widgets/singularity_logo.dart';
import '../../../../../../core/services/onboarding_service.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../injection_container.dart';
import 'widgets/starfield.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final onboarded = await sl<OnboardingService>().isOnboardingComplete();
    final authed = FirebaseAuth.instance.currentUser != null;

    if (!mounted) return;
    if (!onboarded) {
      context.go('/onboarding');
    } else if (authed) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.void_,
      body: Stack(
        children: [
          StarfieldBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingularityMark(size: 56),
                SizedBox(height: 20),
                SingularityWordmark(size: 22, showMark: false),
                SizedBox(height: 12),
                Text(
                  'a window on the universe',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: AppColors.bone3,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.ink3,
              color: AppColors.bone,
              minHeight: 2,
            ),
          ),
        ],
      ),
    );
  }
}
