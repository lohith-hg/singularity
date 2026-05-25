import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_chip.dart';
import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/exoplanet_entity.dart';
import '../bloc/exoplanets_bloc.dart';

class ExoplanetsPage extends StatefulWidget {
  const ExoplanetsPage({super.key});

  @override
  State<ExoplanetsPage> createState() => _ExoplanetsPageState();
}

class _ExoplanetsPageState extends State<ExoplanetsPage> {
  static const _filters = [
    'All',
    'Earth-like',
    'Hot Jupiter',
    'Super-Earth',
    'Habitable',
  ];

  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<ExoplanetsBloc>().add(LoadExoplanetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExoplanetsBloc, ExoplanetsState>(
      listener: (context, state) {
        if (state is ExoplanetsLoaded) {
          setState(() => _activeFilter = state.filter);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0F),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(state)),
                SliverToBoxAdapter(child: _buildFilterRow()),
                if (state is ExoplanetsLoading || state is ExoplanetsInitial)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                else if (state is ExoplanetsError)
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
                else if (state is ExoplanetsLoaded)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == state.planets.length) {
                        return const SizedBox(height: 80);
                      }
                      final planet = state.planets[index];
                      return Column(
                        children: [
                          if (index != 0)
                            const Divider(color: AppColors.hairline, height: 1),
                          _PlanetItem(planet: planet),
                        ],
                      );
                    }, childCount: state.planets.length + 1),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ExoplanetsState state) {
    int count = 0;
    if (state is ExoplanetsLoaded) count = state.planets.length;

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
            'EXOPLANET ARCHIVE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.bone3,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            '$count worlds known.',
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

  Widget _buildFilterRow() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp20),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sp8),
        itemBuilder: (context, i) {
          final f = _filters[i];
          return SChip(
            label: f,
            selected: _activeFilter == f,
            onTap: () {
              setState(() => _activeFilter = f);
              context.read<ExoplanetsBloc>().add(
                FilterExoplanetsEvent(filter: f),
              );
            },
          );
        },
      ),
    );
  }
}

class _PlanetItem extends StatelessWidget {
  const _PlanetItem({required this.planet});
  final ExoplanetEntity planet;

  @override
  Widget build(BuildContext context) {
    final color = _planetColor(planet.radiusEarth);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp20,
        vertical: AppSpacing.sp12,
      ),
      child: Row(
        children: [
          // Planet circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.9),
                  color.withValues(alpha: 0.3),
                ],
                center: const Alignment(-0.3, -0.3),
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
          ),
          const SizedBox(width: AppSpacing.sp12),
          // Name + stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: AppColors.bone,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (planet.distanceParsecs != null)
                      Text(
                        '${planet.distanceParsecs!.toStringAsFixed(1)} pc',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone3,
                        ),
                      ),
                    if (planet.distanceParsecs != null &&
                        planet.massEarth != null)
                      Text(
                        '  ·  ',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone4,
                        ),
                      ),
                    if (planet.massEarth != null)
                      Text(
                        '${planet.massEarth!.toStringAsFixed(1)} M⊕',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone3,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.bone4, size: 18),
        ],
      ),
    );
  }

  Color _planetColor(double? radius) {
    if (radius == null) return const Color(0xFF555249);
    if (radius < 1) return const Color(0xFF7FB069);
    if (radius < 2) return const Color(0xFF1A6B8A);
    if (radius < 4) return const Color(0xFF8A6BB0);
    return const Color(0xFFC1440E);
  }
}
