import 'package:get/get.dart';
import 'package:mastech/modules/chantier/chantier_service.dart';

import '../../helpers/shared_service.dart';
import '../../models/chantier.dart';
import '../../models/utilisateur.dart';

class ChantierController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchChantiers();
  }

  var isLoading = true.obs;
  var chantiersList = <Chantier>[].obs;

  fetchChantiers() async {
    try {
      isLoading(true);
      Utilisateur user = await SharedService().getUserDetails();

      var chantiers = await ChantierService.getChantiers(
          '/chefProjets/${user.id}/chantiers');
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
