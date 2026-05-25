import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../app/widgets/scrim_widget.dart';
import '../../../../../app/widgets/singularity_logo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/shared/entities/apod_entity.dart';
import '../bloc/cosmo_daily_bloc.dart';

class CosmoDailyPage extends StatefulWidget {
  const CosmoDailyPage({super.key});

  @override
  State<CosmoDailyPage> createState() => _CosmoDailyPageState();
}

class _CosmoDailyPageState extends State<CosmoDailyPage> {
  @override
  void initState() {
    super.initState();
    context.read<CosmoDailyBloc>().add(LoadCosmoDailyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CosmoDailyBloc, CosmoDailyState>(
      builder: (context, state) {
        if (state is CosmoDailyLoading || state is CosmoDailyInitial) {
          return const Scaffold(
            backgroundColor: AppColors.ink,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.bone,
                strokeWidth: 1.5,
              ),
            ),
          );
        }

        if (state is CosmoDailyError) {
          return Scaffold(
            backgroundColor: AppColors.ink,
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  color: AppColors.bone3,
                ),
              ),
            ),
          );
        }

        if (state is CosmoDailyLoaded) {
          final pics = state.pictures;
          if (pics.isEmpty) return const SizedBox.shrink();

          final hero = pics.first;
          final weekPics = pics.length > 1
              ? pics.sublist(1, pics.length.clamp(0, 8))
              : <ApodEntity>[];

          return Scaffold(
            backgroundColor: AppColors.ink,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _HeroSection(apod: hero)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp24,
                      AppSpacing.sp32,
                      AppSpacing.sp24,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Body text
                        Text(
                          hero.explanation,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Geist',
                            fontSize: 15,
                            height: 1.55,
                            color: AppColors.bone2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sp32),

                        // Section header — Today across the system
                        const _SectionHeader(title: 'Today across the system'),
                        const SizedBox(height: AppSpacing.sp16),
                        const _SystemGrid(),
                        const SizedBox(height: AppSpacing.sp32),

                        // Section header — This week
                        if (weekPics.isNotEmpty) ...[
                          const _SectionHeader(title: 'This week'),
                          const SizedBox(height: AppSpacing.sp16),
                        ],
                      ],
                    ),
                  ),
                ),

                // Horizontal carousel
                if (weekPics.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sp24,
                        ),
                        itemCount: weekPics.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final pic = weekPics[i];
                          return _WeekThumb(apod: pic);
                        },
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.apod});
  final ApodEntity apod;

  @override
  Widget build(BuildContext context) {
    final isVideo = apod.url.contains('youtube') || apod.url.contains('vimeo');

    return GestureDetector(
      onTap: () => context.push('/apod-detail', extra: apod),
      child: SizedBox(
        height: 460,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!isVideo)
              CachedNetworkImage(
                imageUrl: apod.url,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: AppColors.ink2),
                errorWidget: (_, _, _) => Container(color: AppColors.ink2),
              )
            else
              Container(
                color: AppColors.ink2,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: AppColors.bone3,
                    size: 56,
                  ),
                ),
              ),
            const TopScrim(heightFraction: 0.28),
            const BottomScrim(heightFraction: 0.55),

            // Top bar overlay
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp20,
                  vertical: AppSpacing.sp8,
                ),
                child: Row(
                  children: [
                    const SingularityWordmark(size: 16),
                    const Spacer(),
                    SRoundBtn(
                      onPressed: () => context.push('/search'),
                      child: const Icon(
                        Icons.search,
                        color: AppColors.bone,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom content overlay
            Positioned(
              left: AppSpacing.sp20,
              right: AppSpacing.sp20,
              bottom: AppSpacing.sp24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_formatDate(apod.date)}  ·  APOD'.toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bone3,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp8),
                  Text(
                    apod.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.newsreader(
                      fontSize: 34,
                      height: 1.08,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: AppColors.bone,
                    ),
                  ),
                  if (apod.copyright.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sp8),
                    Text(
                      '© ${apod.copyright}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: AppColors.bone3,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${_monthName(d.month)} ${d.day}';

  String _monthName(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.newsreader(
            fontSize: 22,
            height: 1.2,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: AppColors.bone,
          ),
        ),
      ],
    );
  }
}

class _SystemGrid extends StatelessWidget {
  const _SystemGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      const _GridItem(
        label: 'Mars',
        icon: Icons.radio_button_unchecked,
        color: Color(0xFFC1440E),
        route: '/mars',
      ),
      const _GridItem(
        label: 'Earth',
        icon: Icons.public,
        color: Color(0xFF1A6B8A),
        route: '/epic',
      ),
      const _GridItem(
        label: 'Space weather',
        icon: Icons.wb_sunny,
        color: Color(0xFFE8C26E),
        route: '/donki',
      ),
      const _GridItem(
        label: 'Asteroids',
        icon: Icons.adjust,
        color: AppColors.bone3,
        route: '/neo',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => _SystemTile(item: item)).toList(),
    );
  }
}

class _GridItem {
  const _GridItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _SystemTile extends StatelessWidget {
  const _SystemTile({required this.item});
  final _GridItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.ink1,
          borderRadius: BorderRadius.circular(AppSpacing.sp12),
          border: Border.all(color: AppColors.hairline),
        ),
        padding: const EdgeInsets.all(AppSpacing.sp16),
        child: Row(
          children: [
            Icon(item.icon, color: item.color, size: 24),
            const SizedBox(width: 10),
            Text(
              item.label,
              style: const TextStyle(
                fontFamily: 'Geist',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.bone,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.bone4,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekThumb extends StatelessWidget {
  const _WeekThumb({required this.apod});
  final ApodEntity apod;

  @override
  Widget build(BuildContext context) {
    final isVideo = apod.url.contains('youtube') || apod.url.contains('vimeo');

    return GestureDetector(
      onTap: () => context.push('/apod-detail', extra: apod),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.sp12),
        child: SizedBox(
          width: 110,
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!isVideo)
                CachedNetworkImage(
                  imageUrl: apod.url,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: AppColors.ink2),
                  errorWidget: (_, _, _) => Container(color: AppColors.ink2),
                )
              else
                Container(color: AppColors.ink2),
              const BottomScrim(heightFraction: 0.5),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Text(
                  apod.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bone,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
