import 'package:get/get.dart';

import '../controllers/sky_stories_controller.dart';

class SkyStoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkyStoriesController>(
      () => SkyStoriesController(),
    );
  }
}
