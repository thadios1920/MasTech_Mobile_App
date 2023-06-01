import 'package:get/get.dart';
import 'package:mastech/modules/planEditing/planEditing_controller.dart';

class PlanEditingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanEditingController>(() => PlanEditingController(),
        tag: 'planEditing');
  }
}
