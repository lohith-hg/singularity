import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/controllers/APOD_controller.dart';
import 'package:singularity/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/read_more.dart';

class PictureOftheDayScreen extends StatefulWidget {
  PictureOftheDayScreen({Key? key}) : super(key: key);

  @override
  State<PictureOftheDayScreen> createState() => _PictureOftheDayScreenState();
}

class _PictureOftheDayScreenState extends State<PictureOftheDayScreen> {
  final controller = Get.put(APODController());
  //final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
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
                  launch(
                      'https://github.com/lohith-hg/singularity-privacy/blob/main/privacy-policy.md');
                },
              ),
              ListTile(
                title: Text('About us',
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                onTap: () {
                  launch(
                      'https://github.com/lohith-hg/singularity-privacy/blob/main/About-us.md');
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
                            .contains('www.youtube.com')))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: controller.apodPictures[index].url,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
                        ExpandableText(
                          controller.apodPictures[index].explanation,
                          trimLines: 15,
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
      );
    });
  }

  Future launchEmail(
      {required String toEmail,
      required String subject,
      required String message}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Future saveAndShare(Uint8List? bytes) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final image = File('${directory.path}/singularity.png');
  //   await image.writeAsBytes(bytes!);
  //   await Share.shareFiles([image.path], text: text);
  //   String appLink =
  //       'https://play.google.com/store/apps/details?id=com.lohith.singularity&pli=1';
  //   String text =
  //       'Hey,Check out this singularity app, singularity is an app where you can explore and learn about universe,stars,planets - $appLink';
  //   await Share.share(text);
  // }

  Future shareAppLink() async {
    String appLink =
        'https://play.google.com/store/apps/details?id=com.lohith.singularity&pli=1';
    String text =
        'Hey,Check out this singularity app, singularity is an app where you can explore and learn about universe,stars,planets - $appLink';
    await Share.share(text);
  }

  String getFormattedDate(DateTime date) {
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }
}
