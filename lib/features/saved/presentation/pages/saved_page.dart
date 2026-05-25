import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../shared/entities/apod_entity.dart';
import '../bloc/saved_bloc.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
    // SavedBloc is loaded at HomeView level; trigger a refresh if still initial
    final state = context.read<SavedBloc>().state;
    if (state is SavedInitial) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) context.read<SavedBloc>().add(LoadSavedItemsEvent(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedBloc, SavedState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ink,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sp24,
                    AppSpacing.sp24,
                    AppSpacing.sp24,
                    AppSpacing.sp16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Navigator.of(context).canPop())
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sp16,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.bone,
                                size: 20,
                              ),
                            ),
                          ),
                        Text(
                          'SAVED',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: AppColors.bone4,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sp8),
                        Text(
                          'Your collection.',
                          style: GoogleFonts.newsreader(
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: AppColors.bone,
                            height: 1.15,
                          ),
                        ),
                        if (state is SavedLoaded) ...[
                          const SizedBox(height: AppSpacing.sp8),
                          Text(
                            '${state.items.length} saved',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: AppColors.bone3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (state is SavedLoading || state is SavedInitial)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                else if (state is SavedError)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 13,
                          color: AppColors.bone3,
                        ),
                      ),
                    ),
                  )
                else if (state is SavedLoaded && state.items.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bookmark_outline,
                            color: AppColors.bone4,
                            size: 32,
                          ),
                          const SizedBox(height: AppSpacing.sp16),
                          Text(
                            'Nothing saved yet.',
                            style: GoogleFonts.newsreader(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: AppColors.bone3,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp8),
                          const Text(
                            'Tap the bookmark on any APOD to save it here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 13,
                              color: AppColors.bone4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is SavedLoaded)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp16,
                      0,
                      AppSpacing.sp16,
                      100,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppSpacing.sp8,
                            mainAxisSpacing: AppSpacing.sp8,
                            childAspectRatio: 0.8,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = state.items[index];
                        return _SavedCard(
                          apod: item.apod,
                          onTap: () =>
                              context.push('/apod-detail', extra: item.apod),
                        );
                      }, childCount: state.items.length),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.apod, required this.onTap});
  final ApodEntity apod;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: apod.url,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: AppColors.ink2),
              errorWidget: (_, _, _) => Container(
                color: AppColors.ink2,
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.bone4,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC050507)],
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.sp8),
                child: Text(
                  apod.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.newsreader(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: AppColors.bone,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
