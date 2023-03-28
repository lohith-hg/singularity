import 'package:get/instance_manager.dart';
import 'package:singularity/app/modules/auth/controllers/auth_controller.dart';
import 'package:singularity/app/modules/cosmo_daily/controllers/cosmo_daily_controller.dart';
import 'package:singularity/app/modules/explore/controllers/explore_controller.dart';
import 'package:singularity/app/modules/home/controllers/home_controller.dart';
import 'package:singularity/app/modules/profile/controllers/profile_controller.dart';
import 'package:singularity/app/modules/sky_stories/controllers/sky_stories_controller.dart';
import 'package:singularity/app/modules/vintage_space/controllers/vintage_space_controller.dart';
import 'app/service/auth_service.dart';

class ControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(AuthController());
    Get.put(HomeController());
  }
}