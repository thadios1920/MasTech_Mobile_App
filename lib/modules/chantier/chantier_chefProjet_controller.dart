import 'package:get/get.dart';
import 'package:mastech/modules/chantier/chantier_service.dart';

import '../../helpers/shared_service.dart';
import '../../models/chantier.dart';
import '../../models/login_details.dart';
import '../../models/utilisateur.dart';

class ChantierController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // getRole();

    fetchChantiers();
  }

  var isLoading = true.obs;
  var chantiersList = <Chantier>[].obs;

  var isChefProjet = false.obs;

  var route = ''.obs;

  getRole() async {
    print('in Get role');
    LoginDetails details = await SharedService().getLoginDetails();
    if (details.user!.role!.compareTo("chefProjet") == 0) {
      route.value = '/chefProjets/${details.user!.id}/chantiers';
    } else {
      route.value = '/chefChantiers/${details.user!.id}/chantiers';
    }
    print('role in get role = ${route.value}');
  }

  fetchChantiers() async {
    try {
      await getRole();
      isLoading(true);
      LoginDetails details = await SharedService().getLoginDetails();
      var chantiers = await ChantierService.getChantiers(route.value);
      if (chantiers.isNotEmpty) {
        for (var c in chantiers) {
          chantiersList.add(c);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
