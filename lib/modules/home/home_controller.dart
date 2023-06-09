import 'dart:io';

import 'package:get/get.dart';

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRole();
  }

  var isChefProjet = false.obs;
  var image = File('').obs;
  var nom = ''.obs;
  var email = ''.obs;

  getRole() async {
    print('not chefProjet');
    LoginDetails details = await SharedService().getLoginDetails();
    if (details.user!.role!.compareTo("chefProjet") == 0) {
      isChefProjet.value = true;
      print('isChefProjet');
    }
  }
}
