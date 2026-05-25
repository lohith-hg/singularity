import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverToBoxAdapter(child: _buildHeader(context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList.separated(
              itemCount: _archives.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _ArchiveCard(archive: _archives[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPLORE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: AppColors.bone3,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Eight archives.',
            style: GoogleFonts.newsreader(
              fontSize: 38,
              height: 1.05,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: 20),
          _SearchBar(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  static const List<_Archive> _archives = [
    _Archive(
      eyebrow: 'NASA · APOD',
      title: 'Astronomy Picture of the Day',
      description: 'A new celestial photograph every day since 1995.',
      accentColor: Color(0xFFE8C26E),
      bgColor: Color(0xFF0D0D1A),
      route: null,
    ),
    _Archive(
      eyebrow: 'NASA · Mars 2020',
      title: 'Mars Rover Photos',
      description: 'Raw imagery from Curiosity, Perseverance, and Opportunity.',
      accentColor: Color(0xFFC1440E),
      bgColor: Color(0xFF1A0D0D),
      route: '/mars',
    ),
    _Archive(
      eyebrow: 'NASA · DSCOVR',
      title: 'EPIC Earth',
      description: 'Full-disc Earth imagery updated multiple times daily.',
      accentColor: Color(0xFF1A6B8A),
      bgColor: Color(0xFF0A1218),
      route: '/epic',
    ),
    _Archive(
      eyebrow: 'NASA · NeoWs',
      title: 'Near Earth Objects',
      description: "This week's asteroid close-approach data.",
      accentColor: AppColors.bone3,
      bgColor: Color(0xFF12110A),
      route: '/neo',
    ),
    _Archive(
      eyebrow: 'NASA · DONKI',
      title: 'Space Weather',
      description: 'Solar flares, CMEs, geomagnetic storms, and more.',
      accentColor: AppColors.danger,
      bgColor: Color(0xFF1A0D0D),
      route: '/donki',
    ),
    _Archive(
      eyebrow: 'IPAC · Caltech',
      title: 'Exoplanet Archive',
      description: '5,547+ worlds beyond our solar system.',
      accentColor: Color(0xFF7A6FB0),
      bgColor: Color(0xFF0A0D1A),
      route: '/exoplanets',
    ),
    _Archive(
      eyebrow: 'NASA · Images',
      title: 'Image Library',
      description: '140,000+ historical photos, audio, and video.',
      accentColor: AppColors.good,
      bgColor: Color(0xFF0D120D),
      route: '/library',
    ),
    _Archive(
      eyebrow: 'ESA · Open Notify',
      title: 'ISS Tracker',
      description: 'Live International Space Station position and telemetry.',
      accentColor: AppColors.signal,
      bgColor: Color(0xFF0A0F18),
      route: '/iss',
    ),
  ];
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.ink2,
          borderRadius: BorderRadius.circular(AppSpacing.sp40),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppColors.bone4, size: 17),
            const SizedBox(width: 8),
            Text(
              'Search archives...',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: AppColors.bone4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Archive {
  const _Archive({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.bgColor,
    this.route,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Color accentColor;
  final Color bgColor;
  final String? route;
}

class _ArchiveCard extends StatefulWidget {
  const _ArchiveCard({required this.archive});
  final _Archive archive;

  @override
  State<_ArchiveCard> createState() => _ArchiveCardState();
}

class _ArchiveCardState extends State<_ArchiveCard> {
  bool _pressed = false;

  _Archive get a => widget.archive;

  @override
  Widget build(BuildContext context) {
    final tappable = a.route != null;
    return GestureDetector(
      onTapDown: tappable ? (_) => setState(() => _pressed = true) : null,
      onTapUp: tappable ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: tappable ? () => setState(() => _pressed = false) : null,
      onTap: tappable ? () => context.push(a.route!) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: a.bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent bar
              Container(width: 3, color: a.accentColor),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTextContent()),
                      const SizedBox(width: 12),
                      _buildTrailing(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          a.eyebrow.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: a.accentColor.withValues(alpha: 0.8),
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          a.title,
          style: GoogleFonts.newsreader(
            fontSize: 19,
            height: 1.2,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: AppColors.bone,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          a.description,
          style: const TextStyle(
            fontFamily: 'Geist',
            fontSize: 12,
            height: 1.45,
            color: AppColors.bone3,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    if (a.route != null) {
      return const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Icon(Icons.north_east_rounded, size: 15, color: AppColors.bone4),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.ink3,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'SOON',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 8,
          color: AppColors.bone4,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
