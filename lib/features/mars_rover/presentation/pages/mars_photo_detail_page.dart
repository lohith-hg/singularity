import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/rover_photo_entity.dart';

class MarsPhotoDetailPage extends StatefulWidget {
  const MarsPhotoDetailPage({
    super.key,
    required this.photos,
    required this.initialIndex,
    required this.heroTag,
  });

  final List<RoverPhotoEntity> photos;
  final int initialIndex;
  final String heroTag;

  @override
  State<MarsPhotoDetailPage> createState() => _MarsPhotoDetailPageState();
}

class _MarsPhotoDetailPageState extends State<MarsPhotoDetailPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            // Image viewer — clipped so zoom doesn't bleed into info panel
            Expanded(
              flex: 55,
              child: ClipRect(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.photos.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, index) => _PhotoViewItem(
                    photo: widget.photos[index],
                    heroTag: index == widget.initialIndex
                        ? widget.heroTag
                        : null,
                  ),
                ),
              ),
            ),
            // Info panel — always visible, fades between photos
            Expanded(
              flex: 45,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _InfoPanel(
                  key: ValueKey(widget.photos[_currentIndex].id),
                  photo: widget.photos[_currentIndex],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: AppColors.bone, size: 18),
          ),
          Text(
            '${_currentIndex + 1} / ${widget.photos.length}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.bone3,
            ),
          ),
          _CircleButton(
            onTap: () {},
            child: const Icon(
              Icons.ios_share_outlined,
              color: AppColors.bone,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({super.key, required this.photo});

  final RoverPhotoEntity photo;

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
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E16),
        border: Border(top: BorderSide(color: Color(0xFF1E1E28), width: 1)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo.date.isNotEmpty)
              Text(
                _formatDate(photo.date).toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: AppColors.bone3,
                  letterSpacing: 1.4,
                ),
              ),
            if (photo.title.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                photo.title,
                style: GoogleFonts.newsreader(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.bone,
                  height: 1.25,
                ),
              ),
            ],
            if (photo.description.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(color: Color(0xFF252530), height: 1),
              const SizedBox(height: 14),
              Text(
                photo.description,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 12,
                  color: AppColors.bone3,
                  height: 1.65,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'NASA ID: ${photo.id}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: AppColors.bone3.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoViewItem extends StatefulWidget {
  const _PhotoViewItem({required this.photo, this.heroTag});

  final RoverPhotoEntity photo;
  final String? heroTag;

  @override
  State<_PhotoViewItem> createState() => _PhotoViewItemState();
}

class _PhotoViewItemState extends State<_PhotoViewItem> {
  final _transformController = TransformationController();

  void _onDoubleTapDown(TapDownDetails details) {
    final isZoomed = _transformController.value.getMaxScaleOnAxis() > 1.05;
    if (isZoomed) {
      _transformController.value = Matrix4.identity();
    } else {
      final pos = details.localPosition;
      _transformController.value = Matrix4.identity()
        ..translateByDouble(-pos.dx * 1.5, -pos.dy * 1.5, 0, 1)
        ..scaleByDouble(2.5, 2.5, 1, 1);
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: widget.photo.originalUrl,
      fit: BoxFit.contain,
      placeholder: (_, _) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.bone,
          strokeWidth: 1.5,
        ),
      ),
      errorWidget: (_, _, _) => CachedNetworkImage(
        imageUrl: widget.photo.thumbnailUrl,
        fit: BoxFit.contain,
        errorWidget: (_, _, _) =>
            const Icon(Icons.broken_image, color: AppColors.bone3, size: 48),
      ),
    );

    if (widget.heroTag != null) {
      image = Hero(tag: widget.heroTag!, child: image);
    }

    return GestureDetector(
      onDoubleTapDown: _onDoubleTapDown,
      onDoubleTap: () {},
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 0.5,
        maxScale: 6.0,
        child: Center(child: image),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
