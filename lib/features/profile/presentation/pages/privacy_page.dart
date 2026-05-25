import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                AppSpacing.sp16,
                AppSpacing.sp24,
                AppSpacing.sp24,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    SRoundBtn(
                      onPressed: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.bone,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sp16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SINGULARITY',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.bone4,
                              letterSpacing: 1.6,
                            ),
                          ),
                          Text(
                            'Privacy.',
                            style: GoogleFonts.newsreader(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: AppColors.bone,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                0,
                AppSpacing.sp24,
                AppSpacing.sp40,
              ),
              sliver: SliverList.list(
                children: const [
                  _PrivacySection(
                    title: 'Account data',
                    body:
                        'Singularity stores your profile name, email, saved APOD items, preferences, and wallpaper count in Firebase services tied to your account.',
                  ),
                  _PrivacySection(
                    title: 'NASA data',
                    body:
                        'Space imagery, archive results, asteroid data, Mars imagery, Earth imagery, and space-weather information are loaded from public NASA and astronomy APIs.',
                  ),
                  _PrivacySection(
                    title: 'Device access',
                    body:
                        'Gallery access is only used when you tap Wallpaper on an image APOD. The app does not save images to your device without that action.',
                  ),
                  _PrivacySection(
                    title: 'Controls',
                    body:
                        'You can change alert preferences from Profile. Signing out stops account-specific reads until you sign in again.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sp32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.newsreader(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Geist',
              fontSize: 14,
              height: 1.6,
              color: AppColors.bone3,
            ),
          ),
        ],
      ),
    );
  }
}
