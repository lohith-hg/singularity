import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/controllers/APOD_controller.dart';
import 'package:singularity/controllers/history_album_controller.dart';
import 'package:singularity/widgets/custom_button.dart';

import '../controllers/auth_controller.dart';
import '../widgets/read_more.dart';

class VintageSpaceScreen extends StatelessWidget {
  VintageSpaceScreen({Key? key}) : super(key: key);

  final HistoryAlbumController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text(
            'Vintage Space',
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
                  await controller.onInit();
                },
                child: const Text('Refresh'),
                color: secondaryColor,
              ),
            )
          ],
        ),
        body: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              )
            : ListView.builder(
                controller: controller.pageController.value,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.historyPictures.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 12, left: 8, right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFFEBA4F), width: 0.5),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 5),
                          child: Text(
                            controller.historyPictures[index].data![0].title!,
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
                            "Date created ${getFormattedDate(controller.historyPictures[index].data![0].dateCreated!)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                fontFamily:
                                    GoogleFonts.titilliumWeb().fontFamily,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                        ),
                        if (controller
                                .historyPictures[index].links!.isNotEmpty &&
                            !(controller.historyPictures[index].links![0].href!
                                    .contains('www.youtube.com') ||
                                controller
                                    .historyPictures[index].links![0].href!
                                    .contains('player.vimeo.com')))
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                controller
                                    .historyPictures[index].links![0].href!,
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ExpandableText(
                            controller
                                .historyPictures[index].data![0].description!,
                            trimLines: 4,
                          ),
                        ),
                       
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
