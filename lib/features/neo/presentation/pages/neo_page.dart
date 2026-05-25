import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/neo_entity.dart';
import '../bloc/neo_bloc.dart';

class NeoPage extends StatefulWidget {
  const NeoPage({super.key});

  @override
  State<NeoPage> createState() => _NeoPageState();
}

class _NeoPageState extends State<NeoPage> {
  @override
  void initState() {
    super.initState();
    context.read<NeoBloc>().add(LoadNeosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeoBloc, NeoState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0F),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(state)),
                if (state is NeoLoading || state is NeoInitial)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                else if (state is NeoError)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sp24),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Geist',
                            fontSize: 13,
                            color: AppColors.bone3,
                          ),
                        ),
                      ),
                    ),
                  )
                else if (state is NeoLoaded)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == state.neos.length) {
                        return const SizedBox(height: 80);
                      }
                      final neo = state.neos[index];
                      final isFirst = index == 0;
                      return Column(
                        children: [
                          if (!isFirst)
                            const Divider(color: AppColors.hairline, height: 1),
                          _NeoItem(neo: neo),
                        ],
                      );
                    }, childCount: state.neos.length + 1),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(NeoState state) {
    int neoCount = 0;
    int hazardousCount = 0;

    if (state is NeoLoaded) {
      neoCount = state.neos.length;
      hazardousCount = state.neos.where((n) => n.isHazardous).length;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sp20,
        AppSpacing.sp16,
        AppSpacing.sp20,
        AppSpacing.sp24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SRoundBtn(
                onPressed: () => context.pop(),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.bone,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sp16),
          Text(
            'NEOWS · THIS WEEK',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.bone3,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            '$neoCount close approaches.',
            style: GoogleFonts.newsreader(
              fontSize: 40,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: AppColors.bone,
              height: 1.1,
            ),
          ),
          if (hazardousCount > 0) ...[
            const SizedBox(height: AppSpacing.sp8),
            Text(
              '$hazardousCount potentially hazardous',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: const Color(0xFFD9665A),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sp16),
          const Divider(color: AppColors.hairline, height: 1),
        ],
      ),
    );
  }
}

class _NeoItem extends StatelessWidget {
  const _NeoItem({required this.neo});
  final NeoEntity neo;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final isToday = neo.closeApproachDate == todayStr;

    final date = _parseDate(neo.closeApproachDate);
    final day = date != null ? '${date.day}' : '--';
    final month = date != null ? _monthAbbr(date.month) : '--';

    final distNum = double.tryParse(neo.missDistanceKm) ?? 0.0;
    final distFormatted = _formatDistance(distNum);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp20,
        vertical: AppSpacing.sp16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date column
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Text(
                  day,
                  style: GoogleFonts.newsreader(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: AppColors.bone,
                    height: 1,
                  ),
                ),
                Text(
                  month,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.bone3,
                  ),
                ),
              ],
            ),
          ),
          // Vertical divider
          Container(
            width: 1,
            height: 60,
            color: AppColors.hairline,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sp12),
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        neo.name,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          color: AppColors.bone,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE8C26E)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'TODAY',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: const Color(0xFFE8C26E),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sp4),
                Text(
                  '$distFormatted km miss',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.bone3,
                  ),
                ),
                Text(
                  '≈ ${neo.diameterMaxKm.toStringAsFixed(2)} km diam.',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.bone3,
                  ),
                ),
                if (neo.isHazardous) ...[
                  const SizedBox(height: AppSpacing.sp4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1AD9665A),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFD9665A)),
                    ),
                    child: Text(
                      '⚠ HAZARDOUS',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        color: const Color(0xFFD9665A),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  String _monthAbbr(int m) => const [
    '',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ][m];

  String _formatDistance(double km) {
    if (km >= 1000000) {
      return '${(km / 1000000).toStringAsFixed(2)}M';
    }
    if (km >= 1000) {
      // Insert comma thousands separator
      final s = km.toStringAsFixed(0);
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
      return s;
    }
    return km.toStringAsFixed(0);
  }
}
