import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pfe_mobile_app/models/plan.dart';

import '../models/chantier.dart';
import '../models/chefChantier.dart';
import '../models/etage.dart';
import '../models/projet.dart';
import '../models/element.dart' as element;
import '../models/tache.dart';
import '../models/zone.dart';

var client = http.Client();
const String baseUrl = "http://localhost:8001";

class ApiClient {
  // GET method retourne les projet du chef projet inscrit
  static Future<List<Projet>> getProjets(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Projet.projetFromJSON(tempList);
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<Chantier>> getChantiers(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Chantier.chantierFromJSON(tempList);
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<ChefChantier>> getChefChantier(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return ChefChantier.chefChnatierFromJSON(tempList);
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<Etage>> getEtages(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Etage.etageFromJSON(tempList);
  }

  static Future<List<Tache>> getTaches(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Tache.tacheFromJSON(tempList);
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<element.Element>> getElements(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    if (response.statusCode == 200 && tempList.isNotEmpty) {
      return element.Element.elementFromJSON(tempList);
    } else {
      throw Exception('Failed to load elements');
    }
  }

  // GET method retourne les projet du chef projet inscrit
  static Future getPlan(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data);
    } else {
      throw Exception('Failed to load Plan');
    }
  }

  static Future getZone(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data);
    } else {
      throw Exception('Failed to load Zone');
    }
  }

  //*******Post Requests */

  static affecterDonnesElement(String api, element.Element element) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url, body: jsonEncode(element.toJson()));

    return jsonDecode(response.body);
  }

  static ajouterTache(String api, Tache task) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task));

    if (response.statusCode == 201) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to create task.');
    }
  }

  static modifierTache(String api, Tache task) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task));

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to update task.');
    }
  }

  static ajouterElement(String api, element.Element element) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(element));

    if (response.statusCode == 201) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to create element.');
    }
  }

  static modifierElement(String api, element.Element element) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(element));

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to update element.');
    }
  }

  static affecterElement(String api, bool aff) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({aff: aff}));

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to update element.');
    }
  }

  static ajouterZone(String api, Zone zone) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(zone));

    if (response.statusCode == 201) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to add zone.');
    }
  }
  //Delete Requests

  static supprimmerTache(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to delete Tache.');
    }
  }
}
