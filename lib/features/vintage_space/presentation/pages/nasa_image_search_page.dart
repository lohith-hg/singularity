import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/nasa_image_entity.dart';
import '../bloc/vintage_space_bloc.dart';
import 'vintage_image_detail_page.dart';

class NasaImageSearchPage extends StatefulWidget {
  const NasaImageSearchPage({super.key});

  @override
  State<NasaImageSearchPage> createState() => _NasaImageSearchPageState();
}

class _NasaImageSearchPageState extends State<NasaImageSearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      context.read<VintageSpaceBloc>().add(ClearVintageSpaceSearchEvent());
      return;
    }
    context.read<VintageSpaceBloc>().add(SearchVintageSpaceEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                AppSpacing.sp16,
                AppSpacing.sp24,
                AppSpacing.sp20,
              ),
              sliver: SliverToBoxAdapter(
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
                        const SizedBox(width: AppSpacing.sp16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NASA · IMAGE LIBRARY',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: AppColors.bone4,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              Text(
                                'Search archives.',
                                style: GoogleFonts.newsreader(
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.bone,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sp20),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _submit(),
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 15,
                        color: AppColors.bone,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nebula, Apollo, Mars...',
                        suffixIcon: IconButton(
                          onPressed: _submit,
                          icon: const Icon(Icons.search),
                          color: AppColors.bone,
                          tooltip: 'Search',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<VintageSpaceBloc, VintageSpaceState>(
              builder: (context, state) {
                if (state is VintageSpaceInitial) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _SearchMessage(
                      icon: Icons.travel_explore,
                      title: 'Search NASA imagery',
                      body:
                          'Find mission photography, telescope images, and archive material.',
                    ),
                  );
                }

                if (state is VintageSpaceSearching) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  );
                }

                if (state is VintageSpaceError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _SearchMessage(
                      icon: Icons.error_outline,
                      title: 'Search failed',
                      body: state.message,
                    ),
                  );
                }

                if (state is VintageSpaceLoaded) {
                  if (state.images.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _SearchMessage(
                        icon: Icons.image_not_supported_outlined,
                        title: 'No results',
                        body: 'Try a broader NASA archive query.',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp16,
                      0,
                      AppSpacing.sp16,
                      AppSpacing.sp32,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => NasaImageCard(
                          image: state.images[index],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VintageImageDetailPage(
                                images: state.images,
                                initialIndex: index,
                              ),
                            ),
                          ),
                        ),
                        childCount: state.images.length,
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NasaImageCard extends StatelessWidget {
  const NasaImageCard({super.key, required this.image, this.onTap});

  final NasaImageEntity image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sp16),
        decoration: BoxDecoration(
          color: AppColors.ink1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.hairline),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'archive-${image.imageUrl}',
              child: CachedNetworkImage(
                imageUrl: image.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(height: 200, color: AppColors.ink2),
                errorWidget: (_, _, _) => Container(
                  height: 120,
                  color: AppColors.ink2,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.bone4,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sp16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${image.dateCreated.day}.${image.dateCreated.month.toString().padLeft(2, '0')}.${image.dateCreated.year}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: AppColors.bone4,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  Text(
                    image.title,
                    style: GoogleFonts.newsreader(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bone,
                      height: 1.3,
                    ),
                  ),
                  if (image.description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sp8),
                    Text(
                      image.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 13,
                        color: AppColors.bone3,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.bone4, size: 32),
            const SizedBox(height: AppSpacing.sp16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: AppColors.bone,
              ),
            ),
            const SizedBox(height: AppSpacing.sp8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Geist',
                fontSize: 13,
                height: 1.5,
                color: AppColors.bone3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
