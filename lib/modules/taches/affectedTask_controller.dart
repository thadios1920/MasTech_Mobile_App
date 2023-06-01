import 'package:get/get.dart';
import 'package:mastech/models/chantier.dart';
import 'package:mastech/models/tache.dart';
import 'dart:io';

import 'package:mastech/models/utilisateur.dart';

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';
import 'affectedTask_service.dart';

class AffectedTaskController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    chantier.value = Get.arguments;

    getChefChantiers();
    getRole();
  }

  getRole() async {
    LoginDetails details = await SharedService().getLoginDetails();
    if (details.user!.role!.compareTo("chefProjet") == 0) {
      getTaches('/chantiers/${chantier.value.id}/taches');
    } else {
      getTaches(
          '/chefChantiers/${details.user!.id}/chantier/${chantier.value.id}/taches');
    }
  }

  var image = File('').obs;

  Future<void> terminerTask(int idTask) async {
    await AffectedTaskService.modifierTache('/taches/$idTask/terminer');
    for (Tache t in tachesList) {
      if (t.id == idTask) {
        print("terminer$idTask");
        // Suppression de la tâche de la liste
        tachesList.remove(t);
        break; // Sortir de la boucle après avoir trouvé et supprimé la tâche
      }
    }
  }

  var chantier = Chantier().obs;
  var chefChantiersList = <Utilisateur>[].obs;
  var route = ''.obs;
  var isLoading = true.obs;
  var user = Utilisateur().obs;
  var tachesList = <Tache>[].obs;
  var displayList = <Tache>[].obs;
  var listChoise = <String>['Rectification', 'Nouveau', 'En cours', 'Terminée'];
  var selectedFiltres =
      <String>[].obs; // liste des critéres choisies par le user

  Future<void> validerTask(int idTask) async {
    await AffectedTaskService.modifierTache('/taches/$idTask/valider');
    // Recherche de la tâche correspondant à l'ID donné
    for (Tache t in tachesList) {
      if (t.id == idTask) {
        // Suppression de la tâche de la liste
        tachesList.remove(t);
        break; // Sortir de la boucle après avoir trouvé et supprimé la tâche
      }
    }
  }

  Future<void> deleteTask(int idTask) async {
    await AffectedTaskService.supprimmerTache('/taches/$idTask');

    // Recherche de la tâche correspondant à l'ID donné
    for (Tache t in tachesList) {
      if (t.id == idTask) {
        // Suppression de la tâche de la liste
        tachesList.remove(t);
        break; // Sortir de la boucle après avoir trouvé et supprimé la tâche
      }
    }
  }

  resetTasks() {
    displayList.value = tachesList;
  }

  filtreTask() {
    if (selectedFiltres.isNotEmpty) {
      Set<Tache> displaySet = Set<Tache>.from(tachesList);

      for (var filtre in selectedFiltres) {
        List<Tache> filteredList = [];

        if (filtre == 'Nouveau') {
          filteredList =
              tachesList.where((task) => task.type == 'nouveau').toList();
        } else if (filtre == 'Rectification') {
          filteredList =
              tachesList.where((task) => task.type == 'rectification').toList();
        } else if (filtre == 'Terminée') {
          filteredList = tachesList.where((task) => task.etat!).toList();
        } else if (filtre == 'En cours') {
          filteredList =
              tachesList.where((task) => task.etat == false).toList();
        }

        displaySet = displaySet.intersection(filteredList.toSet());
      }

      displayList.value = displaySet.toList();
    } else {
      resetTasks();
    }
  }

  Future<void> rectifierTask(File imageFile, int idTask, String desc) async {
    await AffectedTaskService.rectifierTache(
      imageFile,
      '/taches/$idTask/rectifier',
      desc,
    );

    for (int i = 0; i < tachesList.length; i++) {
      if (tachesList[i].id == idTask) {
        displayList[i].type = 'rectification';
        image.value = imageFile;
        // displayList.removeAt(i); // Suppression de la tâche de la liste
        break; // Sortir de la boucle après avoir trouvé et supprimé la tâche
      }
    }
  }

  Future<void> getChefChantiers() async {
    var chefChantiers =
        await AffectedTaskService.getChefChantier('/chefchantiers');

    if (chefChantiers.isNotEmpty) {
      chefChantiersList.value = chefChantiers;
    }
  }

  // Methode pour ajouter une tache
  Future<void> createTask(Tache tache, idChef) async {
    var createdTask = await AffectedTaskService.ajouterTache(
        '/taches/$idChef/${chantier.value.id}', tache);
    tachesList.add(createdTask);
  }

  Future<void> getTaches(String api) async {
    try {
      var taches = await AffectedTaskService.getTaches(api);
      if (taches.isNotEmpty) {
        tachesList.value = taches;
        displayList.value = tachesList;
      }
    } catch (e) {
      print(e);
    }
  }
}
