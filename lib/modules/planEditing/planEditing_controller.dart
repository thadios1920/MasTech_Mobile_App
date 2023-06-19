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
    // getElementsWithZones();
    getImage();
  }

  var plan = ''.obs;
  var etage = Etage().obs;
  var isButtonEnabled = false.obs;
  // var selectedPhase = ''.obs;
  var image = File('').obs;
  var zones = <Rect>[].obs;
  var lesZones = <Zone>[].obs;
  var listElems = <element.Element>[].obs;
  var notZonedElems = <element.Element>[].obs;
  // pour convertire les zones apportées de API a Rect
  var elementZoneRectMap = <element.Element, Map<Zone, Rect>>{}.obs;

  int selectedZoneIndex = -1.obs;
  var rects = <Rect>[].obs;

  createZone(Zone zone, idElement) async {
    try {
      var idZone = await PlanEditingService.ajouterZone(
          '/zones/element/$idElement', zone);
      await PlanEditingService.affecterElement('/elements/$idElement/affecte');
      print('1:$elementZoneRectMap');
      Zone newZone = Zone(
          id: idZone,
          elementId: zone.elementId,
          height: zone.height,
          width: zone.width,
          x: zone.x,
          y: zone.y);

      element.Element matchingElement = element.Element();
      Rect rect = Rect.zero;

      for (var elem in listElems) {
        if (elem.id.toString() == idElement) {
          rect = Rect.fromLTWH(zone.x!.toDouble(), zone.y!.toDouble(),
              zone.width!.toDouble(), zone.height!.toDouble());
          zones.add(rect);
          matchingElement = elem;
          // notZonedElems.remove(elem);
        }
      }

      if (matchingElement != null) {
        elementZoneRectMap[matchingElement] = {newZone: rect};
      }

      print('2:$elementZoneRectMap');
    } catch (e) {
      throw (e);
    }
  }

  Future<void> supprimerZone(Zone zone, element.Element elem) async {
    await PlanEditingService.supprimmerZone('/zones/${zone.id}');

    var updatedMap = <element.Element, Map<Zone, Rect>>{};
    var updatedZones =
        List<Rect>.from(zones); // Crée une nouvelle liste mise à jour

    for (var entry in elementZoneRectMap.entries) {
      var element = entry.key;
      var zonesRectMap = entry.value;

      if (!zonesRectMap.containsKey(zone)) {
        updatedMap[element] = zonesRectMap;
      } else {
        // Remplacer la Rect par un objet vide Rect()
        var index = updatedZones.indexOf(zonesRectMap[zone]!);
        updatedZones[index] = Rect.zero;
      }
    }

    elementZoneRectMap.value = updatedMap;
    zones.value = updatedZones;

    // Recherche de l'élément dans listElems et mise à jour de son attribut "affecte"
    var elementToRemove =
        listElems.firstWhere((element) => element.id == elem.id);
    elementToRemove.affecte = false;
    // notZonedElems.add(elementToRemove);
  }

  Future<void> updateElement(element.Element elem, int idElem) async {
    await PlanEditingService.modifierElement('/elements/$idElem', elem);
    print(elem);
    for (int i = 0; i < listElems.length; i++) {
      element.Element e = listElems[i];
      if (e.id == idElem) {
        if (e.largeur != elem.largeur) {
          e.largeur = elem.largeur;
        }
        if (e.hauteur != elem.hauteur) {
          e.hauteur = elem.hauteur;
        }
        if (e.phase != elem.phase) {
          e.phase = elem.phase;
        }

        break;
      }
    }
  }

  Future<void> affecterElement(int idElem) async {
    try {
      await PlanEditingService.affecterElement('/elements/$idElem/affecte');
    } catch (e) {
      throw (e);
    }
  }

  Future<void> getMap() async {
    try {
      listElems.value = await PlanEditingService.getElements(
          "/etages/${etage.value.id}/elements");
      if (listElems.isNotEmpty) {
        for (var elem in listElems) {
          if (elem.affecte == false) {
            notZonedElems.add(elem);
          } else {
            var zone =
                await PlanEditingService.getZone("/elements/${elem.id}/zone");
            var rect = Rect.fromLTWH(zone.x!.toDouble(), zone.y!.toDouble(),
                zone.width!.toDouble(), zone.height!.toDouble());
            zones.add(rect);
            elementZoneRectMap[elem] = {zone: rect};
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage() async {
    await getMap();

    try {
      final response = await http.get(Uri.parse(plan.value));
      if (response.statusCode == 200) {
        if (response.headers['content-type']?.startsWith('image') ?? false) {
          try {
            image.value = File.fromRawPath(response.bodyBytes);
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

  String getElementFromRect(Rect rect) {
    for (var entry in elementZoneRectMap.entries) {
      var element = entry.key;
      var zoneRectMap = entry.value;
      if (zoneRectMap.containsValue(rect)) {
        return element.reference ?? "";
      }
    }
    return "null";
  }
}
