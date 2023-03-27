import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/topics.dart';
import '../../../model/history_album.dart';
import '../../../service/api_service.dart';

class VintageSpaceController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  var historyPictures = <HistoryAlbum>[].obs;
  var isLoading = false.obs;
  var isReadmoreMode = false.obs;
  var random = Random();
  var selectedStrings;

  getHistoryPictures() async {
    // historyPictures.value =
    //     (await LocalService().getHistoryAlbumPictures("jupiter"))!;
    // historyPictures.sort(((a, b) => b.date.compareTo(a.date)));
    isLoading.value = true;
    for (int i = 0; i < selectedStrings.length; i++) {
      print("iteration starts");
      print(i);
      var images =
          (await LocalService().getHistoryAlbumPictures(selectedStrings[i])) ??
              [];
      print(images.length);
      historyPictures.addAll(images);
    }
    historyPictures.shuffle();
    if (historyPictures.isNotEmpty) {
      isLoading.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    var randomStrings = topics.toList()..shuffle(random);
    selectedStrings = randomStrings.take(8).toList();
    print(selectedStrings);
    await getHistoryPictures();
    print("lengthhhhhhhhhhhh");
    print(historyPictures.length);
    super.onInit();
  }

  String getFormattedDate(DateTime date) {
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }
}