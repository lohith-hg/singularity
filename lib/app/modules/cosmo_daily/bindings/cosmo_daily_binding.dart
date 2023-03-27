import 'package:get/get.dart';

import '../controllers/cosmo_daily_controller.dart';

class CosmoDailyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CosmoDailyController>(
      () => CosmoDailyController(),
    );
  }
}
