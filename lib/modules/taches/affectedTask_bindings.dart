import 'package:get/get.dart';

import 'affectedTask_controller.dart';

class AffectedTaskBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AffectedTaskController>(() => AffectedTaskController(),
        tag: 'Task');
  }
}
