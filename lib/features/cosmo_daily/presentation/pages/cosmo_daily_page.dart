import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/urls.dart';
import '../../../../app/widgets/custom_button.dart';
import '../../../../app/widgets/read_more.dart';
import '../bloc/cosmo_daily_bloc.dart';

class CosmoDailyPage extends StatefulWidget {
  const CosmoDailyPage({Key? key}) : super(key: key);

  @override
  State<CosmoDailyPage> createState() => _CosmoDailyPageState();
}

class _CosmoDailyPageState extends State<CosmoDailyPage> {
  // PageController is UI state — it stays in the widget, not the BLoC.
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CosmoDailyBloc>().add(LoadCosmoDailyEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CosmoDailyBloc, CosmoDailyState>(
      builder: (context, state) {
        return UpgradeAlert(
          upgrader: Upgrader(),
          showReleaseNotes: false,
          child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              title: const Text(
                'Singularity',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 2,
              backgroundColor: Colors.black,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(Icons.share),
                    color: Colors.white,
                    onPressed: _shareAppLink,
                  ),
                ),
              ],
            ),
            drawer: _buildDrawer(context),
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(CosmoDailyState state) {
    if (state is CosmoDailyLoading || state is CosmoDailyInitial) {
      return const Center(
        child: CircularProgressIndicator(color: secondaryColor),
      );
    }

    if (state is CosmoDailyError) {
      return Center(
        child: Text(state.message, style: const TextStyle(color: Colors.white)),
      );
    }

    if (state is CosmoDailyLoaded) {
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
                              color: secondaryColor,
                            ),
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _formatDate(pic.date),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 50),
          Column(
            children: [
              const Image(
                height: 150,
                width: 150,
                image: AssetImage('assets/app_icon.png'),
              ),
              Text(
                'Singularity',
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 22,
                  fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ListTile(
            title: Text(
              'Share',
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 18,
                fontFamily: GoogleFonts.titilliumWeb().fontFamily,
              ),
            ),
            leading: const Icon(Icons.share, color: Colors.white),
            onTap: _shareAppLink,
          ),
          ListTile(
            title: Text(
              'Contact us',
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 18,
                fontFamily: GoogleFonts.titilliumWeb().fontFamily,
              ),
            ),
            onTap: () => _launchEmail(
              toEmail: 'lohithhggjc@gmail.com',
              subject: 'Hello developer,',
              message: ' ',
            ),
          ),
          ListTile(
            title: Text(
              'Terms & conditions',
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 18,
                fontFamily: GoogleFonts.titilliumWeb().fontFamily,
              ),
            ),
            onTap: () => launchUrl(Urls().privacyPolicy),
          ),
          ListTile(
            title: Text(
              'About us',
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 18,
                fontFamily: GoogleFonts.titilliumWeb().fontFamily,
              ),
            ),
            onTap: () => launchUrl(Urls().aboutUs),
          ),
        ],
      ),
    );
  }

  Future<void> _shareAppLink() async {
    const appLink =
        'https://play.google.com/store/apps/details?id=com.lohith.singularity&pli=1';
    await Share.share(
      'Hey, check out Singularity — explore the universe, stars, and planets: $appLink',
    );
  }

  Future<void> _launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: 'subject=${Uri.encodeComponent(subject)}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  String _formatDate(DateTime date) => '${date.day}-${date.month}-${date.year}';
}
