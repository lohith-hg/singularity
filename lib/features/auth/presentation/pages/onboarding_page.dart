import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../app/widgets/s_button.dart';
import '../../../../../../app/widgets/scrim_widget.dart';
import '../../../../../../core/services/onboarding_service.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../injection_container.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _begin(BuildContext context) async {
    await sl<OnboardingService>().markOnboardingComplete();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.void_,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hero background
          Image.asset(
            'assets/space_background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Bottom scrim 85%
          const BottomScrim(heightFraction: 0.85),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sp16),
                // Page dots
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Dot(active: true),
                    SizedBox(width: 6),
                    _Dot(active: false),
                    SizedBox(width: 6),
                    _Dot(active: false),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The cosmos,\ndelivered daily.',
                        style: GoogleFonts.newsreader(
                          fontSize: 48,
                          height: 1.05,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppColors.bone,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp16),
                      const Text(
                        'Explore 8 NASA archives — from the Astronomy Picture of the Day to Mars rovers, exoplanets, space weather, and live ISS tracking.',
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15,
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bone2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp40),
                      SizedBox(
                        width: double.infinity,
                        child: SButton(
                          label: 'Begin →',
                          onPressed: () => _begin(context),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp16),
                      Center(
                        child: GestureDetector(
                          onTap: () => _begin(context),
                          child: const Text(
                            'Already orbiting? Sign in',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              color: AppColors.bone3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).padding.bottom +
                            AppSpacing.sp24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.bone : AppColors.bone4,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
