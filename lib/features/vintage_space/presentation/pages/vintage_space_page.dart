import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../bloc/vintage_space_bloc.dart';
import 'nasa_image_search_page.dart';
import 'vintage_image_detail_page.dart';

class VintageSpacePage extends StatefulWidget {
  const VintageSpacePage({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<VintageSpacePage> createState() => _VintageSpacePageState();
}

class _VintageSpacePageState extends State<VintageSpacePage> {
  @override
  void initState() {
    super.initState();
    context.read<VintageSpaceBloc>().add(LoadVintageSpaceEvent());
  }

  // Force a fresh network fetch and keep the spinner up until it resolves.
  Future<void> _onRefresh() async {
    final bloc = context.read<VintageSpaceBloc>();
    bloc.add(RefreshVintageSpaceEvent());
    await bloc.stream
        .firstWhere((s) => s is VintageSpaceLoaded || s is VintageSpaceError)
        .timeout(const Duration(seconds: 20), onTimeout: () => bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VintageSpaceBloc, VintageSpaceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ink,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.signal,
              backgroundColor: AppColors.ink2,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp24,
                      AppSpacing.sp16,
                      AppSpacing.sp24,
                      AppSpacing.sp16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          if (!widget.embedded) ...[
                            SRoundBtn(
                              onPressed: () => context.pop(),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.bone,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sp16),
                          ],
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
                                  'The archive.',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.bone,
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SRoundBtn(
                            onPressed: () => context
                                .read<VintageSpaceBloc>()
                                .add(RefreshVintageSpaceEvent()),
                            child: const Icon(
                              Icons.refresh,
                              color: AppColors.bone,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is VintageSpaceLoading ||
                      state is VintageSpaceInitial)
                    const SliverToBoxAdapter(child: _VintageSpaceShimmer())
                  else if (state is VintageSpaceError)
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
                  else if (state is VintageSpaceLoaded)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sp16,
                        0,
                        AppSpacing.sp16,
                        AppSpacing.sp32,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final image = state.images[index];
                          return NasaImageCard(
                            image: image,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VintageImageDetailPage(
                                  images: state.images,
                                  initialIndex: index,
                                ),
                              ),
                            ),
                          );
                        }, childCount: state.images.length),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VintageSpaceShimmer extends StatelessWidget {
  const _VintageSpaceShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.ink2,
      highlightColor: AppColors.ink3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sp16,
          0,
          AppSpacing.sp16,
          AppSpacing.sp32,
        ),
        child: Column(children: List.generate(5, (_) => _imageCard())),
      ),
    );
  }

  Widget _imageCard() => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sp16),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: AppColors.ink2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(color: AppColors.ink3),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sp16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(80, 10),
                  const SizedBox(height: AppSpacing.sp8),
                  _box(double.infinity, 18),
                  const SizedBox(height: 6),
                  _box(220, 13),
                  const SizedBox(height: 6),
                  _box(180, 13),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _box(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.ink2,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
