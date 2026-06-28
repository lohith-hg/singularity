import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../app/widgets/scrim_widget.dart';
import '../../../../../app/widgets/singularity_logo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/shared/entities/apod_entity.dart';
import '../bloc/cosmo_daily_bloc.dart';

const _kMonths = [
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
];

String _fmtShort(DateTime d) => '${_kMonths[d.month]} ${d.day}';
String _fmtLong(DateTime d) => '${_kMonths[d.month]} ${d.day}, ${d.year}';

bool _isVideo(ApodEntity a) => a.mediaType == 'video';

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
            body: _CosmoDailyShimmer(),
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
          final rest = pics.length > 1 ? pics.sublist(1) : <ApodEntity>[];

          return Scaffold(
            backgroundColor: AppColors.ink,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroSection(apod: hero, allApods: pics, index: 0),
                ),

                // Today's briefing — full story teaser for the hero image
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp24,
                      AppSpacing.sp20,
                      AppSpacing.sp24,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S BRIEFING",
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: AppColors.bone4,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sp12),
                        if (!_isVideo(hero))
                          Text(
                            hero.explanation,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 15,
                              height: 1.55,
                              color: AppColors.bone2,
                            ),
                          )
                        else
                          Text(
                            hero.explanation,
                            style: const TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 15,
                              height: 1.55,
                              color: AppColors.bone2,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sp12),
                        GestureDetector(
                          onTap: () => context.push(
                            '/apod-detail',
                            extra: {'apods': pics, 'index': 0},
                          ),
                          child: const Text(
                            'Read full story →',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.signal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Vertical editorial feed — the rest of the week, image-forward
                if (rest.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sp24,
                        AppSpacing.sp32,
                        AppSpacing.sp24,
                        AppSpacing.sp20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'This week',
                            style: GoogleFonts.newsreader(
                              fontSize: 22,
                              height: 1.2,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              color: AppColors.bone,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sp8),
                          Text(
                            '${rest.length} more',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.bone4,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _ApodFeedCard(
                          apod: rest[i],
                          allApods: pics,
                          index: i + 1,
                        ),
                        childCount: rest.length,
                      ),
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
  const _HeroSection({
    required this.apod,
    required this.allApods,
    required this.index,
  });
  final ApodEntity apod;
  final List<ApodEntity> allApods;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isVideo = _isVideo(apod);

    return GestureDetector(
      onTap: () => context.push(
        '/apod-detail',
        extra: {'apods': allApods, 'index': index},
      ),
      child: SizedBox(
        height: 500,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'apod-${apod.date.toIso8601String()}',
              child: !isVideo
                  ? CachedNetworkImage(
                      imageUrl: apod.url,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      placeholder: (_, _) => Container(color: AppColors.ink2),
                      errorWidget: (_, _, _) =>
                          Container(color: AppColors.ink2),
                    )
                  : apod.thumbnailUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: apod.thumbnailUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      placeholder: (_, _) => Container(color: AppColors.ink2),
                      errorWidget: (_, _, _) =>
                          Container(color: AppColors.ink2),
                    )
                  : Container(color: AppColors.ink2),
            ),
            const TopScrim(heightFraction: 0.28),
            const BottomScrim(heightFraction: 0.6),
            if (isVideo) const Center(child: _PlayBadge(size: 64)),

            // Bottom content overlay
            Positioned(
              left: AppSpacing.sp20,
              right: AppSpacing.sp20,
              bottom: AppSpacing.sp32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SingularityWordmark(size: 18),
                  const SizedBox(height: AppSpacing.sp16),
                  Text(
                    '${_fmtShort(apod.date)}  ·  APOD'.toUpperCase(),
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
}

/// Large image-forward card used in the vertical "This week" feed.
class _ApodFeedCard extends StatelessWidget {
  const _ApodFeedCard({
    required this.apod,
    required this.allApods,
    required this.index,
  });
  final ApodEntity apod;
  final List<ApodEntity> allApods;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isVideo = _isVideo(apod);

    return GestureDetector(
      onTap: () => context.push(
        '/apod-detail',
        extra: {'apods': allApods, 'index': index},
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sp24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sp12),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!isVideo)
                      CachedNetworkImage(
                        imageUrl: apod.url,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 250),
                        placeholder: (_, _) => Container(color: AppColors.ink2),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.ink2,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.bone4,
                            size: 28,
                          ),
                        ),
                      )
                    else if (apod.thumbnailUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: apod.thumbnailUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 250),
                        placeholder: (_, _) => Container(color: AppColors.ink2),
                        errorWidget: (_, _, _) =>
                            Container(color: AppColors.ink2),
                      )
                    else
                      Container(color: AppColors.ink2),
                    const BottomScrim(heightFraction: 0.5),
                    if (isVideo) const Center(child: _PlayBadge(size: 48)),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: Text(
                        '${_fmtLong(apod.date)}  ·  APOD'.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          color: AppColors.bone2,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sp12),
            Text(
              apod.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.newsreader(
                fontSize: 22,
                height: 1.15,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: AppColors.bone,
              ),
            ),
            if (apod.copyright.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '© ${apod.copyright}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: AppColors.bone4,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Circular play button overlaid on video posters.
class _PlayBadge extends StatelessWidget {
  const _PlayBadge({this.size = 56});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.45),
        border: Border.all(
          color: AppColors.bone.withValues(alpha: 0.7),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: AppColors.bone,
        size: size * 0.52,
      ),
    );
  }
}

class _CosmoDailyShimmer extends StatelessWidget {
  const _CosmoDailyShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.ink2,
      highlightColor: AppColors.ink3,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // Hero skeleton
          SliverToBoxAdapter(
            child: Container(height: 500, color: AppColors.ink2),
          ),
          // Briefing text skeleton
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                AppSpacing.sp20,
                AppSpacing.sp24,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(120, 10),
                  const SizedBox(height: AppSpacing.sp12),
                  _shimmerBox(double.infinity, 13),
                  const SizedBox(height: 8),
                  _shimmerBox(double.infinity, 13),
                  const SizedBox(height: 8),
                  _shimmerBox(double.infinity, 13),
                  const SizedBox(height: 8),
                  _shimmerBox(200, 13),
                ],
              ),
            ),
          ),
          // "This week" header skeleton
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                AppSpacing.sp32,
                AppSpacing.sp24,
                AppSpacing.sp20,
              ),
              child: _shimmerBox(120, 22),
            ),
          ),
          // Card skeletons
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sp24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.ink2,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.sp12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp12),
                      _shimmerBox(double.infinity, 20),
                      const SizedBox(height: 6),
                      _shimmerBox(180, 20),
                    ],
                  ),
                ),
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.ink2,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
