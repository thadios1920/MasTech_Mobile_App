import 'package:get/get.dart';
import 'dart:io';

import 'package:mastech/models/utilisateur.dart';
import 'package:mastech/modules/Settings/settings_service.dart';

import '../../helpers/shared_service.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  var isLoading = true.obs;
  var user = Utilisateur().obs;

  updateUser(String nom, File imageFile, String prenom, String email,
      String numTel, String password) async {
    try {
      isLoading(true);
      SettingsService().modifierProfile(
          imageFile,
          '/chefProjets/${user.value.id}',
          nom,
          prenom,
          email,
          numTel,
          password);
    } finally {
      isLoading(false);
    }
  }

  getUser() async {
    user.value = await SharedService().getUserDetails();
  }
}
