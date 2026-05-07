import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../app/widgets/read_more.dart';
import '../bloc/vintage_space_bloc.dart';

class VintageSpacePage extends StatefulWidget {
  const VintageSpacePage({Key? key}) : super(key: key);

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
          backgroundColor: primaryColor,
          appBar: AppBar(
            title: const Text('Vintage Space',
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.black,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 4, top: 10, bottom: 10),
                child: MaterialButton(
                  minWidth: 30,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: secondaryColor,
                  onPressed: () => context
                      .read<VintageSpaceBloc>()
                      .add(RefreshVintageSpaceEvent()),
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

  Widget _buildBody(VintageSpaceState state) {
    if (state is VintageSpaceLoading || state is VintageSpaceInitial) {
      return const Center(
        child: CircularProgressIndicator(color: secondaryColor),
      );
    }

    if (state is VintageSpaceError) {
      return Center(
        child: Text(state.message,
            style: const TextStyle(color: Colors.white)),
      );
    }

    if (state is VintageSpaceLoaded) {
      final images = state.images;
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFEBA4F), width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    image.title,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Date created ${_formatDate(image.dateCreated)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                if (!(image.imageUrl.contains('www.youtube.com') ||
                    image.imageUrl.contains('player.vimeo.com')))
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        image.imageUrl,
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                color: Colors.white),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ExpandableText(image.description, trimLines: 4),
                ),
              ],
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  String _formatDate(DateTime date) =>
      '${date.day}-${date.month}-${date.year}';
}
