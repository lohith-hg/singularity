import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../bloc/iss_tracker_bloc.dart';

class IssTrackerPage extends StatefulWidget {
  const IssTrackerPage({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<IssTrackerPage> createState() => _IssTrackerPageState();
}

class _IssTrackerPageState extends State<IssTrackerPage> {
  @override
  void initState() {
    super.initState();
    context.read<IssTrackerBloc>().add(LoadIssPositionEvent());
  }

  @override
  void dispose() {
    context.read<IssTrackerBloc>().add(IssTrackerStopped());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssTrackerBloc, IssTrackerState>(
      builder: (context, state) {
        double? lat;
        double? lon;

        double? velocity;
        double? altitude;
        String? visibility;

        if (state is IssTrackerUpdated) {
          lat = state.position.lat;
          lon = state.position.lon;
          velocity = state.position.velocity;
          altitude = state.position.altitude;
          visibility = state.position.visibility;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0A0F18),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0A0F18), Color(0xFF16161D)],
                  ),
                ),
              ),
              // World map + ISS marker
              Positioned.fill(
                child: _WorldMapWithIss(lat: lat, lon: lon),
              ),
              // Top buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp16,
                    vertical: AppSpacing.sp8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.embedded)
                        SRoundBtn(
                          onPressed: () => context.pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.bone,
                            size: 18,
                          ),
                        )
                      else
                        const SizedBox(width: 36),
                      SRoundBtn(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Manage ISS alerts in Profile → Preferences',
                              ),
                              backgroundColor: Color(0xFF16161D),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.bone,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom sheet area
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomSheet(
                  state,
                  lat,
                  lon,
                  velocity: velocity,
                  altitude: altitude,
                  visibility: visibility,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheet(
    IssTrackerState state,
    double? lat,
    double? lon, {
    double? velocity,
    double? altitude,
    String? visibility,
  }) {
    final isLoading = state is IssTrackerLoading || state is IssTrackerInitial;
    final isError = state is IssTrackerError;
    final errorMessage = state is IssTrackerError ? state.message : '';

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sp20,
        AppSpacing.sp20,
        AppSpacing.sp20,
        AppSpacing.sp32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0xE60A0F18)],
        ),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.bone,
                strokeWidth: 1.5,
              ),
            )
          : isError
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 13,
                  color: AppColors.bone3,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE · ISS',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: const Color(0xFFE8C26E),
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.sp4),
                Text(
                  'ISS overhead.',
                  style: GoogleFonts.newsreader(
                    fontSize: 32,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: AppColors.bone,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.sp12),
                _buildStatsRow(
                  lat,
                  lon,
                  velocity: velocity,
                  altitude: altitude,
                ),
                const SizedBox(height: AppSpacing.sp12),
                const Divider(color: AppColors.hairline, height: 1),
                const SizedBox(height: AppSpacing.sp8),
                if (visibility != null && visibility.isNotEmpty)
                  _VisibilityBadge(visibility: visibility)
                else
                  const Text(
                    'Acquiring signal…',
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 13,
                      color: AppColors.bone3,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildStatsRow(
    double? lat,
    double? lon, {
    double? velocity,
    double? altitude,
  }) {
    final velocityLabel = velocity != null
        ? '${velocity.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')} km/h'
        : '—';
    final altitudeLabel = altitude != null ? '${altitude.round()} km' : '—';
    return Row(
      children: [
        _StatItem(value: velocityLabel, label: 'VELOCITY'),
        const _VerticalDivider(),
        _StatItem(value: altitudeLabel, label: 'ALTITUDE'),
        const _VerticalDivider(),
        _StatItem(
          value: lat != null ? '${lat.toStringAsFixed(1)}°' : '—',
          label: 'LAT',
        ),
        const _VerticalDivider(),
        _StatItem(
          value: lon != null ? '${lon.toStringAsFixed(1)}°' : '—',
          label: 'LON',
        ),
      ],
    );
  }
}

class _WorldMapWithIss extends StatelessWidget {
  const _WorldMapWithIss({this.lat, this.lon});
  final double? lat;
  final double? lon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapWidth = constraints.maxWidth;
        final mapHeight = constraints.maxHeight * 0.6;

        double? x;
        double? y;
        if (lat != null && lon != null) {
          x = (lon! + 180) / 360 * mapWidth;
          y = (90 - lat!) / 180 * mapHeight;
        }

        return Stack(
          children: [
            // Simple stylized world representation using a grid
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: mapHeight,
              child: CustomPaint(painter: _WorldGridPainter()),
            ),
            // ISS marker
            if (x != null && y != null)
              Positioned(
                left: x - 18,
                top: y - 18,
                child: CustomPaint(
                  size: const Size(36, 36),
                  painter: _IssMarkerPainter(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _WorldGridPainter extends CustomPainter {
  // SVG coordinates are in a 360x180 space matching the equirectangular projection.
  // Each unit = 1 degree (x: lon+180, y: 90-lat).
  static const _continents = [
    // North America
    [55,30, 60,28, 70,25, 80,22, 90,24, 95,28, 100,32, 105,38, 108,45, 105,52, 100,58, 95,62, 90,68, 85,72, 80,75, 75,78, 72,82, 70,85, 65,88, 60,90, 55,88, 52,84, 50,80, 48,75, 46,68, 45,62, 44,55, 44,48, 46,42, 50,36],
    // Central America
    [72,88, 75,92, 73,96, 70,98, 68,95, 70,91],
    // Greenland
    [80,10, 90,8, 100,10, 105,15, 102,22, 95,25, 86,24, 80,18],
    // South America
    [72,98, 78,96, 85,98, 92,102, 96,108, 98,116, 96,124, 92,130, 86,135, 80,138, 74,136, 70,130, 68,122, 66,114, 66,106, 68,100],
    // Europe
    [155,28, 162,26, 170,26, 178,28, 182,32, 180,38, 175,42, 170,44, 165,46, 160,48, 155,46, 152,42, 152,36],
    // Scandinavia
    [162,18, 168,16, 172,20, 170,26, 164,27, 160,24],
    // Africa
    [155,52, 162,50, 170,50, 178,52, 182,58, 184,66, 184,76, 182,86, 178,96, 172,104, 166,110, 160,112, 154,110, 150,104, 148,96, 148,86, 148,76, 150,66, 152,58],
    // Russia / Asia
    [178,22, 195,18, 215,16, 235,18, 250,22, 262,28, 268,34, 265,40, 256,44, 244,46, 230,48, 215,50, 200,50, 188,48, 180,44, 178,38],
    // Middle East
    [182,46, 192,44, 200,46, 205,52, 202,58, 196,60, 188,58, 182,54],
    // India
    [208,52, 218,50, 225,54, 226,62, 222,70, 216,74, 210,70, 206,62],
    // Southeast Asia
    [238,50, 250,48, 260,50, 268,56, 266,62, 258,66, 248,65, 240,60],
    // China
    [228,34, 245,32, 260,34, 268,40, 265,48, 252,50, 238,50, 228,46, 224,40],
    // Japan
    [275,32, 280,30, 284,34, 282,40, 277,42, 274,38],
    // Australia
    [250,108, 265,104, 280,106, 292,112, 296,120, 292,128, 282,134, 268,136, 255,132, 246,124, 244,116],
    // New Zealand
    [302,126, 308,124, 312,128, 310,134, 305,136, 302,131],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 360.0;
    final sy = size.height / 180.0;

    // Grid lines (6% opacity)
    final gridPaint = Paint()
      ..color = const Color(0x0FF4F2EE)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    for (final lat in [45.0, 90.0, 135.0]) {
      canvas.drawLine(Offset(0, lat * sy), Offset(size.width, lat * sy), gridPaint);
    }
    for (final lon in [60.0, 120.0, 180.0, 240.0, 300.0]) {
      canvas.drawLine(Offset(lon * sx, 0), Offset(lon * sx, size.height), gridPaint);
    }

    // Continent fills (4% opacity) and strokes (35% opacity)
    final fillPaint = Paint()
      ..color = const Color(0x0AF4F2EE)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0x59F4F2EE)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (final pts in _continents) {
      final path = Path()..moveTo(pts[0] * sx, pts[1] * sy);
      for (int i = 2; i < pts.length; i += 2) {
        path.lineTo(pts[i] * sx, pts[i + 1] * sy);
      }
      path.close();
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IssMarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer ring
    final ringPaint = Paint()
      ..color = const Color(0x40E8C26E)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 18, ringPaint);

    // Inner dot
    final dotPaint = Paint()
      ..color = const Color(0xFFE8C26E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: AppColors.bone4,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _VisibilityBadge extends StatelessWidget {
  const _VisibilityBadge({required this.visibility});
  final String visibility;

  @override
  Widget build(BuildContext context) {
    final label = visibility.toUpperCase();
    final Color color;
    if (visibility == 'daylight') {
      color = const Color(0xFFE8C26E);
    } else if (visibility == 'eclipsed') {
      color = AppColors.bone3;
    } else {
      color = AppColors.bone4;
    }
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Geist',
            fontSize: 13,
            color: color,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
