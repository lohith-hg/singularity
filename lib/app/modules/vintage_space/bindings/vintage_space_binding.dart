import 'package:get/get.dart';

import '../controllers/vintage_space_controller.dart';

class VintageSpaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VintageSpaceController>(
      () => VintageSpaceController(),
    );
  }
}
