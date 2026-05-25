import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_chip.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/rover_photo_entity.dart';
import '../bloc/mars_rover_bloc.dart';
import 'mars_photo_detail_page.dart';

class MarsRoverPage extends StatefulWidget {
  const MarsRoverPage({super.key});

  @override
  State<MarsRoverPage> createState() => _MarsRoverPageState();
}

class _MarsRoverPageState extends State<MarsRoverPage> {
  static const _roverKeys = ['all', 'curiosity', 'perseverance', 'opportunity'];
  static const _roverLabels = [
    'All',
    'Curiosity',
    'Perseverance',
    'Opportunity',
  ];

  int _tabIndex = 0; // default: All
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_tabIndex == index) return;
    setState(() => _tabIndex = index);
    context.read<MarsRoverBloc>().add(
      SelectRoverEvent(rover: _roverKeys[index]),
    );
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - 300) return;
    final state = context.read<MarsRoverBloc>().state;
    if (state is! MarsRoverLoaded) return;
    final activeRover = state.activeRover;
    if (activeRover == 'all') return;
    if (!state.isLoadingMore && !state.hasReachedEnd) {
      context.read<MarsRoverBloc>().add(
        LoadMoreRoverPhotosEvent(
          rover: activeRover,
          nextPage: state.currentPage + 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarsRoverBloc, MarsRoverState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ink,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildFilterRow(),
                const SizedBox(height: AppSpacing.sp8),
                Expanded(child: _buildContent(state)),
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
        AppSpacing.sp20,
        AppSpacing.sp20,
        AppSpacing.sp12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MARS · ACTIVE ROVERS',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: AppColors.bone4,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'From the\nred planet.',
            style: GoogleFonts.newsreader(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: AppColors.bone,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp20),
        itemCount: _roverLabels.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: AppSpacing.sp8),
        itemBuilder: (_, i) => SChip(
          label: _roverLabels[i],
          selected: _tabIndex == i,
          onTap: () => _onTabChanged(i),
        ),
      ),
    );
  }

  Widget _buildContent(MarsRoverState state) {
    if (state is MarsRoverLoading || state is MarsRoverInitial) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.bone,
          strokeWidth: 1.5,
        ),
      );
    }

    if (state is MarsRoverError) {
      return Center(
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
      );
    }

    if (state is MarsRoverLoaded) {
      final photos = state.currentPhotos;

      // Switching to a rover that hasn't been fetched yet
      if (photos.isEmpty && state.activeRover != 'all') {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.bone,
            strokeWidth: 1.5,
          ),
        );
      }

      if (photos.isEmpty) {
        return Center(
          child: Text(
            'No photos loaded yet.\nSelect a rover tab to load images.',
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: AppColors.bone3,
              height: 1.6,
            ),
          ),
        );
      }

      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sp16,
              0,
              AppSpacing.sp16,
              AppSpacing.sp16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sp16),
                  child: _PhotoCard(
                    photo: photos[index],
                    index: index,
                    total: photos.length,
                    roverLabel: _roverLabelFor(photos[index]),
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black,
                        pageBuilder: (_, _, _) => MarsPhotoDetailPage(
                          photos: photos,
                          initialIndex: index,
                          heroTag: 'mars-card-${photos[index].id}',
                        ),
                        transitionsBuilder: (_, anim, _, child) =>
                            FadeTransition(opacity: anim, child: child),
                      ),
                    ),
                  ),
                );
              }, childCount: photos.length),
            ),
          ),
          SliverToBoxAdapter(
            child: state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : state.hasReachedEnd
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                    child: Center(
                      child: Text(
                        'All photos loaded',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone4,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 100),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  String _roverLabelFor(RoverPhotoEntity photo) {
    final t = photo.title.toLowerCase();
    if (t.contains('perseverance')) return 'Perseverance';
    if (t.contains('curiosity')) return 'Curiosity';
    if (t.contains('opportunity')) return 'Opportunity';
    if (t.contains('spirit')) return 'Spirit';
    // Fallback from active tab
    final active = _roverKeys[_tabIndex];
    if (active == 'all') return 'Rover';
    return active[0].toUpperCase() + active.substring(1);
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.photo,
    required this.index,
    required this.total,
    required this.roverLabel,
    required this.onTap,
  });

  final RoverPhotoEntity photo;
  final int index;
  final int total;
  final String roverLabel;
  final VoidCallback onTap;

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
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
      final now = DateTime.now();
      final isToday =
          dt.year == now.year && dt.month == now.month && dt.day == now.day;
      if (isToday) return 'today';
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw.isNotEmpty ? raw.substring(0, 10) : '';
    }
  }

  String _locationHint() {
    final t = photo.title.toUpperCase();
    if (t.contains('GALE CRATER')) return 'GALE CRATER · MARS';
    if (t.contains('JEZERO')) return 'JEZERO CRATER · MARS';
    if (t.contains('MERIDIANI')) return 'MERIDIANI PLANUM · MARS';
    if (t.contains('VICTORIA')) return 'VICTORIA CRATER · MARS';
    if (t.contains('ENDURANCE')) return 'ENDURANCE CRATER · MARS';
    if (t.contains('EAGLE')) return 'EAGLE CRATER · MARS';
    return '$roverLabel · MARS';
  }

  String _shortTitle() {
    String t = photo.title;
    // Strip the rover name from the start if present
    for (final prefix in [
      'Curiosity Mars Rover ',
      'Perseverance Mars Rover ',
      'Opportunity Mars Rover ',
      'Mars Exploration Rover Opportunity ',
      'Mars Exploration Rover Curiosity ',
      'NASA Mars Rover ',
      'Mars Rover ',
    ]) {
      if (t.toLowerCase().startsWith(prefix.toLowerCase())) {
        t = t.substring(prefix.length);
        break;
      }
    }
    return t.isNotEmpty ? t : photo.title;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: AppColors.ink2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildImageSection(), _buildInfoPanel()],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'mars-card-${photo.id}',
            child: CachedNetworkImage(
              imageUrl: photo.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: AppColors.ink3),
              errorWidget: (_, _, _) => Container(
                color: AppColors.ink3,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.bone4,
                  size: 32,
                ),
              ),
            ),
          ),
          // Top scrim
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom scrim
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Top-left: rover badge
          Positioned(top: 12, left: 12, child: _Badge(label: '• $roverLabel')),
          // Top-right: date badge
          Positioned(
            top: 12,
            right: 12,
            child: _Badge(label: _formatDate(photo.date)),
          ),
          // Bottom-right: photo counter
          Positioned(
            bottom: 12,
            right: 12,
            child: Text(
              '${index + 1} / $total',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: AppColors.bone.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _locationHint(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: AppColors.bone3,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _shortTitle(),
            style: GoogleFonts.newsreader(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: AppColors.bone,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bone.withValues(alpha: 0.15)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          color: AppColors.bone2,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
