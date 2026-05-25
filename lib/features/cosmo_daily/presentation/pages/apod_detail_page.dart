import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/widgets/s_button.dart';
import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../app/widgets/scrim_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/profile/domain/usecases/increment_wallpaper_count.dart';
import '../../../../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../../../../features/shared/entities/apod_entity.dart';
import '../../../../../injection_container.dart';

class ApodDetailPage extends StatefulWidget {
  const ApodDetailPage({super.key, required this.apod});
  final ApodEntity apod;

  @override
  State<ApodDetailPage> createState() => _ApodDetailPageState();
}

class _ApodDetailPageState extends State<ApodDetailPage> {
  bool _isSaved = false;
  bool _isSavingWallpaper = false;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
    if (_uid != null) {
      context.read<SavedBloc>().add(LoadSavedItemsEvent(_uid!));
    }
  }

  bool _checkIsSaved(SavedState state) {
    if (state is SavedLoaded) {
      return state.items.any((item) => item.apod.date == widget.apod.date);
    }
    return _isSaved;
  }

  Future<void> _toggleSave() async {
    if (_uid == null) return;
    if (_isSaved) {
      context.read<SavedBloc>().add(
        UnsaveApodEvent(
          uid: _uid!,
          apodDate: widget.apod.date.toIso8601String(),
        ),
      );
    } else {
      context.read<SavedBloc>().add(
        SaveApodEvent(uid: _uid!, apod: widget.apod),
      );
    }
  }

  Future<void> _saveWallpaper() async {
    final url = widget.apod.hdurl.isNotEmpty
        ? widget.apod.hdurl
        : widget.apod.url;
    if (url.isEmpty || widget.apod.mediaType != 'image') return;

    setState(() => _isSavingWallpaper = true);
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final name =
          'singularity_${widget.apod.title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
      await Gal.putImageBytes(bytes, name: name);
      if (_uid != null) {
        try {
          await sl<IncrementWallpaperCount>()(_uid!);
        } catch (_) {
          // The image is already saved locally; profile stats can recover later.
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to gallery'),
            backgroundColor: AppColors.ink2,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save image'),
            backgroundColor: AppColors.ink2,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingWallpaper = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVideo =
        widget.apod.url.contains('youtube') ||
        widget.apod.url.contains('vimeo');

    return BlocConsumer<SavedBloc, SavedState>(
      listener: (context, state) {
        setState(() => _isSaved = _checkIsSaved(state));
      },
      builder: (context, state) {
        final isSaved = _checkIsSaved(state);

        return Scaffold(
          backgroundColor: AppColors.ink,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              // Hero
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 520,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!isVideo)
                        CachedNetworkImage(
                          imageUrl: widget.apod.hdurl.isNotEmpty
                              ? widget.apod.hdurl
                              : widget.apod.url,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: AppColors.ink2),
                          errorWidget: (_, _, _) =>
                              Container(color: AppColors.ink2),
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
                      const TopScrim(heightFraction: 0.25),
                      const BottomScrim(heightFraction: 0.35),

                      // Top buttons
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sp16),
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
                              const Spacer(),
                              SRoundBtn(
                                onPressed: _toggleSave,
                                child: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isSaved
                                      ? AppColors.signal
                                      : AppColors.bone,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SRoundBtn(
                                onPressed: () => SharePlus.instance.share(
                                  ShareParams(
                                    text:
                                        '${widget.apod.title}\n${widget.apod.url}',
                                  ),
                                ),
                                child: const Icon(
                                  Icons.share,
                                  color: AppColors.bone,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sp24),

                      // Date eyebrow
                      Text(
                        _formatDate(widget.apod.date).toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bone3,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp12),

                      // Title
                      Text(
                        widget.apod.title,
                        style: GoogleFonts.newsreader(
                          fontSize: 40,
                          height: 1.05,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: AppColors.bone,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp20),

                      // Metadata row
                      Row(
                        children: [
                          if (widget.apod.copyright.isNotEmpty) ...[
                            _MetaCell(
                              label: 'CREDIT',
                              value: widget.apod.copyright,
                            ),
                            _VerticalDivider(),
                          ],
                          _MetaCell(
                            label: 'TYPE',
                            value: widget.apod.mediaType == 'image'
                                ? 'Image'
                                : 'Video',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sp24),

                      const Divider(color: AppColors.hairline),
                      const SizedBox(height: AppSpacing.sp24),

                      // Body
                      Text(
                        widget.apod.explanation,
                        style: const TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15,
                          height: 1.55,
                          color: AppColors.bone2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sp32),

                      // Action buttons
                      Row(
                        children: [
                          if (!isVideo)
                            Expanded(
                              child: _isSavingWallpaper
                                  ? const SizedBox(
                                      height: 48,
                                      child: Center(
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: AppColors.bone,
                                            strokeWidth: 1.5,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SButton.ghost(
                                      label: 'Wallpaper',
                                      onPressed: _saveWallpaper,
                                    ),
                            ),
                          if (!isVideo) const SizedBox(width: 12),
                          Expanded(
                            child: SButton.ghost(
                              label: isSaved ? 'Saved ✓' : 'Save',
                              onPressed: _uid != null ? _toggleSave : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime d) =>
      '${_monthName(d.month)} ${d.day}, ${d.year}';

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

class _MetaCell extends StatelessWidget {
  const _MetaCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: AppColors.bone4,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: AppColors.bone2,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.hairlineStrong,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
