import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/space_weather_event_entity.dart';
import '../bloc/donki_bloc.dart';

class DonkiPage extends StatefulWidget {
  const DonkiPage({super.key});

  @override
  State<DonkiPage> createState() => _DonkiPageState();
}

class _DonkiPageState extends State<DonkiPage> {
  @override
  void initState() {
    super.initState();
    context.read<DonkiBloc>().add(LoadSpaceWeatherEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonkiBloc, DonkiState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0F),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                if (state is DonkiLoading || state is DonkiInitial)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                else if (state is DonkiError)
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
                else if (state is DonkiLoaded) ...[
                  SliverToBoxAdapter(child: _buildStatusTile(state.events)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sp20,
                        AppSpacing.sp24,
                        AppSpacing.sp20,
                        0,
                      ),
                      child: Text(
                        'RECENT EVENTS',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone3,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == state.events.length) {
                        return const SizedBox(height: 80);
                      }
                      final evt = state.events[index];
                      return Column(
                        children: [
                          if (index != 0)
                            const Divider(
                              color: AppColors.hairline,
                              height: 1,
                              indent: AppSpacing.sp20,
                              endIndent: AppSpacing.sp20,
                            ),
                          _EventItem(event: evt),
                        ],
                      );
                    }, childCount: state.events.length + 1),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sp20,
        AppSpacing.sp16,
        AppSpacing.sp20,
        AppSpacing.sp8,
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
            'SPACE WEATHER · DONKI',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.bone3,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            'Solar activity.',
            style: GoogleFonts.newsreader(
              fontSize: 40,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: AppColors.bone,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sp16),
        ],
      ),
    );
  }

  Widget _buildStatusTile(List<SpaceWeatherEventEntity> events) {
    final gstEvents = events.where((e) => e.type == 'GST').toList();
    final topKp = gstEvents.isNotEmpty
        ? gstEvents.where((e) => e.kpIndex != null).fold<double?>(null, (
            prev,
            e,
          ) {
            if (prev == null) return e.kpIndex;
            return e.kpIndex! > prev ? e.kpIndex : prev;
          })
        : null;

    final isActive = topKp != null && topKp > 4;
    final kpDisplay = topKp != null ? topKp.toStringAsFixed(1) : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF16161D),
          border: Border.all(color: AppColors.hairline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    size: 64,
                    color: isActive ? const Color(0xFFE8C26E) : AppColors.bone4,
                  ),
                  const SizedBox(height: AppSpacing.sp8),
                  Text(
                    'KP-INDEX',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: AppColors.bone4,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Text(
                    kpDisplay,
                    style: GoogleFonts.newsreader(
                      fontSize: 32,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: AppColors.bone,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.sp12,
              right: AppSpacing.sp12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0x26E8C26E)
                      : const Color(0x267FB069),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFE8C26E)
                        : const Color(0xFF7FB069),
                  ),
                ),
                child: Text(
                  isActive ? 'ACTIVE' : 'QUIET',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: isActive
                        ? const Color(0xFFE8C26E)
                        : const Color(0xFF7FB069),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  const _EventItem({required this.event});
  final SpaceWeatherEventEntity event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp20,
        vertical: AppSpacing.sp12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.bone3),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              event.type,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: AppColors.bone3,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sp12),
          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 13,
                    color: AppColors.bone2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(event.time),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.bone4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    // "2024-01-15T12:00Z" or "2024-01-15T12:00:00.000Z"
    if (time.isEmpty) return '—';
    final parts = time.split('T');
    if (parts.length < 2) return time;
    final timePart = parts[1].replaceAll('Z', '').split('.').first;
    return '${parts[0]} ${timePart.substring(0, timePart.length.clamp(0, 5))} UTC';
  }
}
