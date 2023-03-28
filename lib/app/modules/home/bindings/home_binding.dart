import 'package:get/get.dart';
import '../../cosmo_daily/controllers/cosmo_daily_controller.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../sky_stories/controllers/sky_stories_controller.dart';
import '../../vintage_space/controllers/vintage_space_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put(CosmoDailyController());
    Get.put(SkyStoriesController());
    Get.put(VintageSpaceController());
    Get.put(ExploreController());
    Get.put(ProfileController());
  }
}
