import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/colors.dart';
import '../../../constants/urls.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/read_more.dart';
import '../controllers/cosmo_daily_controller.dart';

class CosmoDailyView extends GetView<CosmoDailyController> {
  const CosmoDailyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return UpgradeAlert(
        upgrader: Upgrader(showReleaseNotes: false),
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
                  onPressed: () async {
                    await shareAppLink();
                    // final image = await screenshotController.capture();
                    // saveAndShare(image!);
                  },
                ),
              ),
            ],
          ),
          drawer: Drawer(
            backgroundColor: primaryColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    const Image(
                      height: 150,
                      width: 150,
                      image: AssetImage(
                        'assets/app_icon.png',
                      ),
                    ),
                    Text('Singulatity',
                        style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 22,
                            fontFamily: GoogleFonts.titilliumWeb().fontFamily))
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: Text('Share',
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                  leading: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    await shareAppLink();
                    // final image = await screenshotController.capture();
                    // saveAndShare(image!);
                  },
                ),
                ListTile(
                  title: Text('Contact us',
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                  onTap: () {
                    launchEmail(
                        toEmail: 'lohithhggjc@gmail.com',
                        subject: 'Hello developer,',
                        message: ' ');
                  },
                ),
                ListTile(
                  title: Text('Terms & conditions',
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                  onTap: () {
                    launchUrl(Urls().privacyPolicy);
                  },
                ),
                ListTile(
                  title: Text('About us',
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                  onTap: () {
                    launchUrl(Urls().aboutUs);
                  },
                ),
              ],
            ),
          ),
          body: controller.isAPODLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : PageView.builder(
                  controller: controller.pageController.value,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.apodPictures.length,
                  itemBuilder: ((context, index) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (!(controller.apodPictures[index].url
                                  .contains('www.youtube.com') ||
                              controller.apodPictures[index].url
                                  .contains('player.vimeo.com')))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                controller.apodPictures[index].url,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
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
                              controller.apodPictures[index].title,
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
                              getFormattedDate(
                                  controller.apodPictures[index].date),
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
                            child: ExpandableText(
                              controller.apodPictures[index].explanation,
                              trimLines: 15,
                            ),
                          ),
                          // if (controller.isReadmoreMode.value)
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
                                    name: "Previous",
                                    onTap: () {
                                      controller.pageController.value
                                          .previousPage(
                                              duration: const Duration(
                                                  microseconds: 200),
                                              curve: Curves.linear);
                                    },
                                  ),
                                if (index != controller.apodPictures.length)
                                  Button(
                                    width: 0.25,
                                    height: 35,
                                    backgroundColor: secondaryColor,
                                    borderColor: secondaryColor,
                                    textColor: primaryColor,
                                    name: "Next",
                                    onTap: () {
                                      controller.pageController.value.nextPage(
                                          duration:
                                              const Duration(microseconds: 200),
                                          curve: Curves.linear);
                                    },
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
        ),
      );
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future launchEmail(
      {required String toEmail,
      required String subject,
      required String message}) async {
    // final url =
    //     'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'toEmail',
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  // Future saveAndShare(Uint8List? bytes) async {
  Future shareAppLink() async {
    String appLink = Urls().appLink;
    String text =
        'Hey,Check out this singularity app, singularity is an app where you can explore and learn about universe,stars,planets - $appLink';
    await Share.share(text);
  }

  String getFormattedDate(DateTime date) {
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }
}