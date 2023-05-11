import 'package:get/get.dart';

import 'etage_controller.dart';

class EtageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EtageController>(() => EtageController(), tag: 'etage');
  }
}
