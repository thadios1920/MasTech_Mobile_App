import 'package:get/get.dart';
import 'package:mastech/models/plan.dart';
import 'package:mastech/models/utilisateur.dart';

import '../../helpers/shared_service.dart';
import '../../models/etage.dart';
import 'etage_service.dart';

class EtageController extends GetxController {
  final String id = "2";
  @override
  void onInit() {
    super.onInit();
    fetchEtages();
  }

  var isLoading = true.obs;
  var etagesList = <Etage>[].obs;
  var planList = [].obs;
  // var id = "".obs;

  fetchEtages() async {
    try {
      isLoading(true);

      var etages = await EtageService.getEtages('/chantiers/$id/etages');
      if (etages.isNotEmpty) {
        for (var e in etages) {
          etagesList.add(e);
        }
        print(etagesList.length);
        await getPlan();
      }
    } finally {
      isLoading(false);
    }
  }

  getPlan() async {
    try {
      for (var i = 0; i < etagesList.length; i++) {
        var plan =
            await EtageService.getPlan("/etages/${etagesList[i].id}/plan");
        planList.add(plan);
        print(plan);
      }
      print(planList.length);
    } catch (e) {
      print(e);
    }
  }

  Map<Etage, Plan> getEtagePlanMap() {
    Map<Etage, Plan> etagePlanMap = {};
    for (var i = 0; i < etagesList.length; i++) {
      var etage = etagesList[i];
      for (var j = 0; j < planList.length; j++) {
        var plan = planList[j];
        if (plan.etageId == etage.id) {
          etagePlanMap[etage] = plan;
          break;
        }
      }
    }
    return etagePlanMap;
  }
}
