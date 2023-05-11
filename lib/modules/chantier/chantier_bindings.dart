import 'package:get/get.dart';
import 'package:mastech/modules/chantier/chantier_chefProjet_controller.dart';

class ChantierBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChantierController>(() => ChantierController(),
        tag: 'chantier');
  }
}
