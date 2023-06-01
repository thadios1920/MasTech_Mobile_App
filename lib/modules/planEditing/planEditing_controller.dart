import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:mastech/models/etage.dart';
import 'package:mastech/modules/planEditing/planEditing_service.dart';

import '../../models/zone.dart';
import '../../models/element.dart' as element;

class PlanEditingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    etage.value = Get.arguments['etage'];
    plan.value = Get.arguments['plan'];
    getImage();
  }

  var plan = ''.obs;
  var etage = Etage().obs;

  var image = File('').obs;
  var zones = <Rect>[].obs;
  var lesZones = <Zone>[].obs;
  var listElems = <element.Element>[].obs;
  var notZonedElems = <element.Element>[].obs;
  var zonesList = [].obs;

  int selectedZoneIndex = -1.obs;
  var rects = <Rect>[].obs;

  // Methode pour ajouter une zone
  createZone(Zone zone, idElement) async {
    await PlanEditingService.ajouterZone('/zones/element/$idElement', zone);

    zones.add(Rect.fromLTWH(zone.x!.toDouble(), zone.y!.toDouble(),
        zone.width!.toDouble(), zone.height!.toDouble()));
  }

  Future<void> supprimerZone(Zone zone) async {
    print(zone);
    await PlanEditingService.supprimmerZone('/zones/${zone.id}');
    zones.remove(Rect.fromLTWH(zone.x!.toDouble(), zone.y!.toDouble(),
        zone.width!.toDouble(), zone.height!.toDouble()));
  }

  Future<void> updateElement(element.Element elem, int idElem) async {
    await PlanEditingService.modifierElement('/elements/$idElem', elem);

    for (int i = 0; i < listElems.length; i++) {
      element.Element e = listElems[i];
      if (e.id == idElem) {
        // Modification de l'élément dans la liste
        listElems[i] = elem;
        break; // Sortir de la boucle après avoir trouvé et modifié l'élément
      }
    }
  }

  Future<void> affecterElement(int idElem) async {
    await PlanEditingService.affecterElement('/elements/$idElem/affecte');
  }

  Future<void> getListZones() async {
    try {
      for (var i = 0; i < listElems.length; i++) {
        var zone = await PlanEditingService.getZone(
            "/elements/${listElems[i].id}/zone");

        zonesList.add(zone);

        Zone newZone = Zone(
            id: zonesList[i]['id'],
            x: int.parse(zonesList[i]['x']),
            y: int.parse(zonesList[i]['y']),
            width: int.parse(zonesList[i]['width']),
            height: int.parse(zonesList[i]['height']));
        lesZones.add(newZone);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getElements() async {
    listElems.value = await PlanEditingService.getElements(
        "/etages/${etage.value.id}/elements");

    if (listElems.isNotEmpty) {
      await getListZones();
      for (var elem in listElems) {
        if (elem.affecte == false) {
          notZonedElems.add(elem);
        }
      }
    }
  }

  Future<void> getImage() async {
    await getElements();

    try {
      final response = await http.get(Uri.parse(plan.value));
      if (response.statusCode == 200) {
        if (response.headers['content-type']?.startsWith('image') ?? false) {
          try {
            image.value = File.fromRawPath(response.bodyBytes);

            zones.addAll(lesZones.map((zone) => Rect.fromLTWH(
                zone.x!.toDouble(),
                zone.y!.toDouble(),
                zone.width!.toDouble(),
                zone.height!.toDouble())));
          } catch (e) {
            print('Error creating File object: $e'); // Debugging statement
          }
        } else {
          print('Response is not an image file');
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error retrieving image: $e');
    }
  }
}
