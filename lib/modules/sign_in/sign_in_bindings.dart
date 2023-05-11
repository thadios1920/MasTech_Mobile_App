import 'package:get/get.dart';

import 'sign_in_controller.dart';

class SignInBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController(), tag: 'login');
  }
}
