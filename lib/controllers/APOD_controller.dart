import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:singularity/data/picture_of_the_day.dart';

import '../service/api_service.dart';

class APODController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  var feedPictures = <PictureOfTheDay>[].obs;
  var apodPictures = <PictureOfTheDay>[].obs;
  var isAPODLoading = true.obs;
  var isFeedLoading = true.obs;
  var isReadmoreMode = false.obs;

  getFeedPictures() async {
    feedPictures.value = (await LocalService().getPictures(30))!;
    feedPictures.shuffle();
    if (feedPictures.isNotEmpty) {
      isFeedLoading.value = false;
    }
  }

  getAPODPictures() async {
    apodPictures.value = (await LocalService().getPictures(7))!;
    apodPictures.sort(((a, b) => b.date.compareTo(a.date)));
    if (apodPictures.isNotEmpty) {
      isAPODLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    await getAPODPictures();
    await getFeedPictures();
    super.onInit();
  }
}