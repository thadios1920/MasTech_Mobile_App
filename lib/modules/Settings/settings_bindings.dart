import 'package:get/get.dart';
import 'package:mastech/modules/Settings/settings_controller.dart';


class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController(), tag: 'settings');
  }
}
