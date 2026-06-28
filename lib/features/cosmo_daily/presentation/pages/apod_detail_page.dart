import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../app/widgets/scrim_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../../../../features/shared/entities/apod_entity.dart';

class ApodDetailPage extends StatefulWidget {
  const ApodDetailPage({
    super.key,
    required this.apods,
    required this.initialIndex,
  });
  final List<ApodEntity> apods;
  final int initialIndex;

  @override
  State<ApodDetailPage> createState() => _ApodDetailPageState();
}

class _ApodDetailPageState extends State<ApodDetailPage> {
  late final PageController _pageController;
  late int _currentIndex;

  // Inline playback — the page currently playing, or null when nothing is.
  // YouTube videos play through [_ytController]; everything else (Vimeo, etc.)
  // plays through an inline WebView and leaves [_ytController] null.
  int? _playingIndex;
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    context.read<SavedBloc>().add(const LoadSavedItemsEvent());
    // Auto-play if the APOD we open on is a YouTube video.
    final id = _youtubeIdFor(_currentIndex);
    if (id != null) {
      _playingIndex = _currentIndex;
      _ytController = _buildController(id);
    }
  }

  @override
  void dispose() {
    _ytController?.close();
    _pageController.dispose();
    super.dispose();
  }

  /// Returns the YouTube video id for [index], or null if it isn't a YouTube
  /// video (image, or a non-YouTube embed such as Vimeo).
  String? _youtubeIdFor(int index) {
    final apod = widget.apods[index];
    if (apod.mediaType != 'video') return null;
    // `convertUrlToId` only matches https URLs, but some APOD entries still
    // use http — normalise first so those play inline instead of falling
    // through to the generic WebView path.
    final url = apod.url.trim().replaceFirst(RegExp(r'^http://'), 'https://');
    return YoutubePlayerController.convertUrlToId(url);
  }

  YoutubePlayerController _buildController(String videoId) =>
      YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: false,
          strictRelatedVideos: true,
        ),
      );

  void _stopPlayback() {
    _ytController?.close();
    _ytController = null;
    _playingIndex = null;
  }

  void _startYoutube(int index, String videoId) {
    _ytController?.close();
    _playingIndex = index;
    _ytController = _buildController(videoId);
  }

  // Start inline playback for a non-YouTube video — the page renders an inline
  // WebView when it's the playing index with no YouTube controller.
  void _startWeb(int index) {
    _ytController?.close();
    _ytController = null;
    _playingIndex = index;
  }

  // The active page changed — auto-play it if it's a YouTube video, otherwise
  // stop whatever was playing (non-YouTube videos play on tap, not on swipe).
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      final id = _youtubeIdFor(index);
      if (id != null) {
        _startYoutube(index, id);
      } else if (_playingIndex != null) {
        _stopPlayback();
      }
    });
  }

  // Manual play (poster play button). Plays in place on the same screen — a
  // YouTube iframe when we can resolve a video id, otherwise an inline WebView.
  void _play(int index) {
    final id = _youtubeIdFor(index);
    setState(() {
      if (id != null) {
        _startYoutube(index, id);
      } else {
        _startWeb(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedBloc, SavedState>(
      builder: (context, savedState) {
        final apod = widget.apods[_currentIndex];
        final isSaved = savedState is SavedLoaded
            ? savedState.items.any((item) => item.apod.date == apod.date)
            : false;

        return Scaffold(
          backgroundColor: AppColors.ink,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.apods.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => _ApodPage(
                  apod: widget.apods[index],
                  useHero: index == widget.initialIndex,
                  isPlaying: index == _playingIndex,
                  ytController: index == _playingIndex ? _ytController : null,
                  onPlay: () => _play(index),
                ),
              ),

              // Persistent overlay — back, counter, bookmark
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp16,
                    vertical: AppSpacing.sp8,
                  ),
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
                      if (widget.apods.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sp8),
                          child: Text(
                            '${_currentIndex + 1} / ${widget.apods.length}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: AppColors.bone3,
                            ),
                          ),
                        ),
                      SRoundBtn(
                        onPressed: () {
                          context.read<SavedBloc>().add(
                            isSaved
                                ? UnsaveApodEvent(
                                    apodDate: apod.date.toIso8601String(),
                                  )
                                : SaveApodEvent(apod: apod),
                          );
                        },
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? AppColors.signal : AppColors.bone,
                          size: 18,
                        ),
                      ),
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
}

class _ApodPage extends StatelessWidget {
  const _ApodPage({
    required this.apod,
    required this.useHero,
    required this.isPlaying,
    required this.ytController,
    required this.onPlay,
  });
  final ApodEntity apod;
  final bool useHero;
  final bool isPlaying;
  final YoutubePlayerController? ytController;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final isVideo = apod.mediaType == 'video';
    final showPlayer = isVideo && isPlaying;

    final Widget heroChild;
    if (showPlayer) {
      // Play in place: the video takes over the same hero area the poster
      // occupied — full width, vertically centred on the same screen — so it
      // reads as the poster coming to life rather than a tiny player pinned to
      // the top with the details shoved underneath. YouTube uses the iframe
      // player; anything else (Vimeo, etc.) gets an inline WebView.
      heroChild = ColoredBox(
        color: Colors.black,
        child: ytController != null
            ? Center(
                child: YoutubePlayer(
                  controller: ytController!,
                  aspectRatio: 16 / 9,
                ),
              )
            : _InlineWebVideo(url: apod.url),
      );
    } else {
      Widget imageWidget;
      if (isVideo) {
        // Show the poster thumbnail; playback happens via the play button.
        imageWidget = apod.thumbnailUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: apod.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: AppColors.ink2),
                errorWidget: (_, _, _) => Container(color: AppColors.ink2),
              )
            : Container(color: AppColors.ink2);
      } else {
        // Standard-res image, already cached from the list/hero — shows
        // instantly so the Hero transition is seamless and nothing is blank.
        final hasHd = apod.hdurl.isNotEmpty && apod.hdurl != apod.url;
        final Widget standardImage = CachedNetworkImage(
          imageUrl: apod.url,
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(color: AppColors.ink2),
          errorWidget: (_, _, _) => Container(color: AppColors.ink2),
        );
        imageWidget = hasHd
            // Paint the cached standard image immediately, then fade the
            // full-res HD version in on top once it finishes downloading.
            ? CachedNetworkImage(
                imageUrl: apod.hdurl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                placeholder: (_, _) => standardImage,
                errorWidget: (_, _, _) => standardImage,
              )
            : standardImage;
      }

      if (useHero) {
        imageWidget = Hero(
          tag: 'apod-${apod.date.toIso8601String()}',
          child: imageWidget,
        );
      }

      heroChild = Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          const TopScrim(heightFraction: 0.25),
          const BottomScrim(heightFraction: 0.35),
          if (isVideo)
            Center(
              child: GestureDetector(onTap: onPlay, child: const _PlayButton()),
            ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 520, child: heroChild)),
        SliverToBoxAdapter(child: _details(context)),
      ],
    );
  }

  Widget _details(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sp24),

          Text(
            _formatDate(apod.date).toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.bone3,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sp12),

          Text(
            apod.title,
            style: GoogleFonts.newsreader(
              fontSize: 40,
              height: 1.05,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: AppColors.bone,
            ),
          ),
          const SizedBox(height: AppSpacing.sp24),

          const Divider(color: AppColors.hairline),
          const SizedBox(height: AppSpacing.sp24),

          Text(
            apod.explanation,
            style: const TextStyle(
              fontFamily: 'Geist',
              fontSize: 15,
              height: 1.55,
              color: AppColors.bone2,
            ),
          ),
          const SizedBox(height: AppSpacing.sp24),

          const Divider(color: AppColors.hairline),
          const SizedBox(height: AppSpacing.sp20),

          // Credit / type meta — below the description. The CREDIT cell is
          // flexible so long attributions wrap instead of overflowing on narrow
          // screens; IntrinsicHeight keeps the divider matched to its height.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (apod.copyright.isNotEmpty) ...[
                  Flexible(
                    child: _MetaCell(label: 'CREDIT', value: apod.copyright),
                  ),
                  _VerticalDivider(),
                ],
                _MetaCell(
                  label: 'TYPE',
                  value: apod.mediaType == 'image' ? 'Image' : 'Video',
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
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

/// Centered play affordance shown over a video poster on the detail page.
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.45),
            border: Border.all(
              color: AppColors.bone.withValues(alpha: 0.8),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.bone,
            size: 38,
          ),
        ),
        const SizedBox(height: AppSpacing.sp12),
        Text(
          'PLAY VIDEO',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: AppColors.bone2,
            letterSpacing: 1.6,
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

/// Inline WebView player for non-YouTube video APODs (e.g. Vimeo). Renders in
/// the detail page's hero area — same screen, no navigation. YouTube videos use
/// the dedicated iframe player instead; this is the catch-all fallback.
class _InlineWebVideo extends StatefulWidget {
  const _InlineWebVideo({required this.url});

  final String url;

  @override
  State<_InlineWebVideo> createState() => _InlineWebVideoState();
}

class _InlineWebVideoState extends State<_InlineWebVideo> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final PlatformWebViewControllerCreationParams params =
        WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(_playableUrl(widget.url)));

    // Android: allow autoplay without a user gesture.
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}

/// Normalises an APOD video URL into an autoplaying, inline embed URL. Handles
/// YouTube `watch?v=` / `youtu.be` short forms and preserves existing query
/// params; non-YouTube URLs are passed through with autoplay flags.
String _playableUrl(String raw) {
  var url = raw.trim().replaceFirst(RegExp(r'^http://'), 'https://');

  final watch = RegExp(r'youtube\.com/watch\?v=([\w-]+)').firstMatch(url);
  if (watch != null) {
    url = 'https://www.youtube.com/embed/${watch.group(1)}';
  }
  final short = RegExp(r'youtu\.be/([\w-]+)').firstMatch(url);
  if (short != null) {
    url = 'https://www.youtube.com/embed/${short.group(1)}';
  }

  final isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
  final extra = isYouTube
      ? {'playsinline': '1', 'autoplay': '1', 'rel': '0'}
      : {'playsinline': '1', 'autoplay': '1'};

  final uri = Uri.parse(url);
  return uri
      .replace(queryParameters: {...uri.queryParameters, ...extra})
      .toString();
}
