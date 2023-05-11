import 'package:get/get.dart';

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRole();
  }

  var isChefProjet = true.obs;

  getRole() async {
    print("chefProjetBeforeCondition$isChefProjet");
    LoginDetails details = await SharedService().getLoginDetails();
    if (details.user!.role!.compareTo("chefProjet") == 0) {
      isChefProjet(true);
      print("chefProjetAfterCondition$isChefProjet");
    }
  }
}
