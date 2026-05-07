import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../app/widgets/custom_button.dart';
import '../../../../app/widgets/read_more.dart';
import '../bloc/sky_stories_bloc.dart';

class SkyStoriesPage extends StatefulWidget {
  const SkyStoriesPage({Key? key}) : super(key: key);

  @override
  State<SkyStoriesPage> createState() => _SkyStoriesPageState();
}

class _SkyStoriesPageState extends State<SkyStoriesPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<SkyStoriesBloc>().add(LoadSkyStoriesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkyStoriesBloc, SkyStoriesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            title: const Text('Singularity',
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.black,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 4, top: 10, bottom: 10),
                child: MaterialButton(
                  minWidth: 30,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: secondaryColor,
                  onPressed: () =>
                      context.read<SkyStoriesBloc>().add(ShuffleSkyStoriesEvent()),
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SkyStoriesState state) {
    if (state is SkyStoriesLoading || state is SkyStoriesInitial) {
      return const Center(
        child: CircularProgressIndicator(color: secondaryColor),
      );
    }

    if (state is SkyStoriesError) {
      return Center(
        child: Text(state.message,
            style: const TextStyle(color: Colors.white)),
      );
    }

    if (state is SkyStoriesLoaded) {
      final pictures = state.pictures;
      return PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: pictures.length,
        itemBuilder: (context, index) {
          final pic = pictures[index];
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                if (!(pic.url.contains('www.youtube.com') ||
                    pic.url.contains('player.vimeo.com')))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      pic.url,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 300,
                          width: 300,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: secondaryColor),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    pic.title,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ExpandableText(pic.explanation, trimLines: 15),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (index != 0)
                        Button(
                          width: 0.25,
                          height: 35,
                          backgroundColor: primaryColor,
                          borderColor: secondaryColor,
                          textColor: secondaryColor,
                          name: 'Previous',
                          onTap: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          ),
                        ),
                      if (index != pictures.length - 1)
                        Button(
                          width: 0.25,
                          height: 35,
                          backgroundColor: secondaryColor,
                          borderColor: secondaryColor,
                          textColor: primaryColor,
                          name: 'Next',
                          onTap: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
