import 'package:get/get.dart';
import 'package:mastech/modules/chantier/chantier_service.dart';

import '../../models/chantier.dart';

class ChantierController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchChantiers();
  }

  var isLoading = true.obs;
  var chantiersList = <Chantier>[].obs;
  var avancement = 0.obs;

  fetchChantiers() async {
    try {
      isLoading(true);
      var chantiers =
          await ChantierService.getChantiers('/chefChantiers/2/chantiers');
      if (chantiers.isNotEmpty) {
        for (var c in chantiers) {
          chantiersList.add(c);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  // getAvancement() async {
  //   try {
  //     var chantiers =
  //         await ChantierService.getChantiers('/chefChantiers/2/chantiers');
  //     if (chantiers.isNotEmpty) {
  //       for (var c in chantiers) {
  //         chantiersList.add(c);
  //       }
  //     }
  //   } catch (e) {
  //     throw ("Failed to get Avancement");
  //   }
  // }
}
