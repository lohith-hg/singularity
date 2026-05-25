import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../app/widgets/scrim_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/epic_image_entity.dart';
import '../bloc/epic_bloc.dart';

class EpicPage extends StatefulWidget {
  const EpicPage({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<EpicPage> createState() => _EpicPageState();
}

class _EpicPageState extends State<EpicPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<EpicBloc>().add(LoadEpicImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpicBloc, EpicState>(
      builder: (context, state) {
        if (state is EpicLoading || state is EpicInitial) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0A0F),
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.bone,
                strokeWidth: 1.5,
              ),
            ),
          );
        }

        if (state is EpicError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0A0F),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 13,
                  color: AppColors.bone3,
                ),
              ),
            ),
          );
        }

        if (state is EpicLoaded) {
          final images = state.images;
          if (images.isEmpty) {
            return const Scaffold(
              backgroundColor: Color(0xFF0A0A0F),
              body: Center(
                child: Text(
                  'No images available.',
                  style: TextStyle(fontFamily: 'Geist', color: AppColors.bone3),
                ),
              ),
            );
          }

          final selected = images[_selectedIndex.clamp(0, images.length - 1)];

          return Scaffold(
            backgroundColor: const Color(0xFF0A0A0F),
            body: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: selected.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: const Color(0xFF0A0A0F)),
                  errorWidget: (_, _, _) =>
                      Container(color: const Color(0xFF0A0A0F)),
                ),
                const BottomScrim(heightFraction: 0.55),
                // Top-left overlay: back button + coords
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp16,
                      vertical: AppSpacing.sp8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.embedded)
                          SRoundBtn(
                            onPressed: () => context.pop(),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.bone,
                              size: 18,
                            ),
                          ),
                        if (!widget.embedded)
                          const SizedBox(width: AppSpacing.sp12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'LAT ${selected.lat.toStringAsFixed(2)}° · LON ${selected.lon.toStringAsFixed(2)}°',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                color: AppColors.bone3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selected.date.split(' ').first,
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
                ),
                // Bottom content
                Positioned(
                  left: AppSpacing.sp20,
                  right: AppSpacing.sp20,
                  bottom: AppSpacing.sp32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'EPIC · DSCOVR',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone3,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp8),
                      Text(
                        'Earth, full disc.',
                        style: GoogleFonts.newsreader(
                          fontSize: 32,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: AppColors.bone,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp4),
                      Text(
                        '${images.length} frames today',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.bone3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp16),
                      _buildScrubber(images),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildScrubber(List<EpicImageEntity> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(images.length, (i) {
            final isSelected = i == _selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.bone : AppColors.ink3,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatUtcTime(images.first.date),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: AppColors.bone4,
              ),
            ),
            Text(
              _formatUtcTime(images.last.date),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: AppColors.bone4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatUtcTime(String date) {
    // "2024-01-15 00:31:45" -> "00:31 UTC"
    final parts = date.split(' ');
    if (parts.length < 2) return date;
    final timeParts = parts[1].split(':');
    if (timeParts.length < 2) return parts[1];
    return '${timeParts[0]}:${timeParts[1]} UTC';
  }
}
