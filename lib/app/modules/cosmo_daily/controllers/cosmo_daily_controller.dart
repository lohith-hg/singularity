import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/picture_of_the_day.dart';
import '../../../service/api_service.dart';

class CosmoDailyController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  var apodPictures = <PictureOfTheDay>[].obs;
  var isAPODLoading = true.obs;
  var isReadmoreMode = false.obs;

  getAPODPictures() async {
    apodPictures.value =
        (await LocalService().getPictures(DateTime.now(), 30))!;
    apodPictures.sort(((a, b) => b.date.compareTo(a.date)));
    if (apodPictures.isNotEmpty) {
      isAPODLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    await getAPODPictures();
    super.onInit();
  }
}
