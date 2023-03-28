import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/picture_of_the_day.dart';
import '../../../service/api_service.dart';

class SkyStoriesController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  var feedPictures = <PictureOfTheDay>[].obs;
  var isFeedLoading = true.obs;
  var isReadmoreMode = false.obs;

  getFeedPictures() async {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 10));
    feedPictures.value = (await LocalService().getPictures(startDate, 40))!;
    feedPictures.shuffle();
    if (feedPictures.isNotEmpty) {
      isFeedLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    await getFeedPictures();
    super.onInit();
  }
}
