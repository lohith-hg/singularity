import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/widgets/s_round_btn.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../bloc/vintage_space_bloc.dart';
import 'nasa_image_search_page.dart';

class VintageSpacePage extends StatefulWidget {
  const VintageSpacePage({super.key});

  @override
  State<VintageSpacePage> createState() => _VintageSpacePageState();
}

class _VintageSpacePageState extends State<VintageSpacePage> {
  @override
  void initState() {
    super.initState();
    context.read<VintageSpaceBloc>().add(LoadVintageSpaceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VintageSpaceBloc, VintageSpaceState>(
      builder: (context, state) {
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
                    AppSpacing.sp16,
                  ),
                  sliver: SliverToBoxAdapter(
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
                          onPressed: () => context.read<VintageSpaceBloc>().add(
                            RefreshVintageSpaceEvent(),
                          ),
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
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bone,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
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
                        return NasaImageCard(image: image);
                      }, childCount: state.images.length),
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
