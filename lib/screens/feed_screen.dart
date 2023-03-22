import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/controllers/APOD_controller.dart';
import 'package:singularity/widgets/custom_button.dart';

import '../controllers/auth_controller.dart';
import '../widgets/read_more.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);

  final controller = Get.put(APODController());
  AuthController authController = Get.find();

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
              padding: const EdgeInsets.only(right: 4, top: 10, bottom: 10),
              child: MaterialButton(
                minWidth: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  // controller.feedPictures.shuffle();
                  await AuthController.authService.signOut();
                },
                child: const Text('Refresh'),
                color: secondaryColor,
              ),
            )
          ],
        ),
        body: controller.isFeedLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              )
            : PageView.builder(
                controller: controller.pageController.value,
                scrollDirection: Axis.horizontal,
                itemCount: controller.feedPictures.length,
                itemBuilder: ((context, index) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        if (!(controller.feedPictures[index].url
                                .contains('www.youtube.com') ||
                            controller.feedPictures[index].url
                                .contains('player.vimeo.com')))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              controller.feedPictures[index].url,
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
                            controller.feedPictures[index].title,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.titilliumWeb().fontFamily,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: ExpandableText(
                            controller.feedPictures[index].explanation,
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
                              if (index != controller.feedPictures.length)
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

  String getFormattedDate(DateTime date) {
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }
}
