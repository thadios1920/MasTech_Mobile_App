import 'dart:convert';

import 'package:mastech/config/config.dart';
import 'package:http/http.dart' as http;

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';
import '../../models/zone.dart';
import '../../models/element.dart' as element;

class PlanEditingService {
  static Future getZone(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data);
    } else {
      throw Exception('Failed to load Zone');
    }
  }

  static affecterElement(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to update element.');
    }
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<element.Element>> getElements(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

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

  static ajouterZone(String api, Zone zone) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(zone));

    if (response.statusCode == 201) {
      // si la création est réussie, retourne la zone créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to add zone.');
    }
  }

  static supprimmerZone(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to delete Zone.');
    }
  }

  static affecterDonnesElement(String api, element.Element element) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(element.toJson()));

    return jsonDecode(response.body);
  }

  static ajouterElement(String api, element.Element element) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
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
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
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
}
