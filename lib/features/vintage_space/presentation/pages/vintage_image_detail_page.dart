import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/nasa_image_entity.dart';

/// Full-screen detail view for Archive (NASA Image Library) images. Mirrors the
/// Mars photo detail screen: a swipeable, zoomable image viewer over an info
/// panel with the full description in the same larger body text.
class VintageImageDetailPage extends StatefulWidget {
  const VintageImageDetailPage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  final List<NasaImageEntity> images;
  final int initialIndex;

  @override
  State<VintageImageDetailPage> createState() => _VintageImageDetailPageState();
}

class _VintageImageDetailPageState extends State<VintageImageDetailPage> {
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
            // Image viewer — clipped so zoom doesn't bleed into the info panel.
            Expanded(
              flex: 55,
              child: ClipRect(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, index) => _ImageViewItem(
                    image: widget.images[index],
                    heroTag: index == widget.initialIndex
                        ? 'archive-${widget.images[index].imageUrl}'
                        : null,
                  ),
                ),
              ),
            ),
            // Info panel — always visible, fades between images.
            Expanded(
              flex: 45,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _InfoPanel(
                  key: ValueKey(widget.images[_currentIndex].imageUrl),
                  image: widget.images[_currentIndex],
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
            '${_currentIndex + 1} / ${widget.images.length}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.bone3,
            ),
          ),
          // Balances the close button so the counter stays centred.
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({super.key, required this.image});

  final NasaImageEntity image;

  String _formatDate(DateTime dt) {
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
            Text(
              _formatDate(image.dateCreated).toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: AppColors.bone3,
                letterSpacing: 1.4,
              ),
            ),
            if (image.title.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                image.title,
                style: GoogleFonts.newsreader(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.bone,
                  height: 1.25,
                ),
              ),
            ],
            if (image.description.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(color: Color(0xFF252530), height: 1),
              const SizedBox(height: 14),
              Text(
                image.description,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 15,
                  height: 1.55,
                  color: AppColors.bone2,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ImageViewItem extends StatefulWidget {
  const _ImageViewItem({required this.image, this.heroTag});

  final NasaImageEntity image;
  final String? heroTag;

  @override
  State<_ImageViewItem> createState() => _ImageViewItemState();
}

class _ImageViewItemState extends State<_ImageViewItem> {
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
      imageUrl: widget.image.imageUrl,
      fit: BoxFit.contain,
      placeholder: (_, _) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.bone,
          strokeWidth: 1.5,
        ),
      ),
      errorWidget: (_, _, _) =>
          const Icon(Icons.broken_image, color: AppColors.bone3, size: 48),
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
