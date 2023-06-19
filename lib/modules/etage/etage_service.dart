import 'dart:convert';

import 'package:mastech/config/config.dart';
import 'package:mastech/helpers/shared_service.dart';
import 'package:mastech/models/etage.dart';
import 'package:http/http.dart' as http;

import '../../models/login_details.dart';

var client = http.Client();

class EtageService {
  // GET method retourne les etages du chef projet inscrit
  static Future<List<Etage>> getEtages(String api) async {
    try {
      var url = Uri.parse(Config.baseURL + api);
      LoginDetails details = await SharedService().getLoginDetails();
      String token = details.token!;
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List tempList = [];
        for (var v in data) {
          tempList.add(v);
        }
        return Etage.etageFromJSON(tempList);
      } else {
        throw Exception('Failed to load etages');
      }
    } catch (e) {
      throw Exception('Failed to load etages');
    }
  }

  // GET method retourne les projet du chef projet inscrit
  static Future getPlan(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data);
    } else {
      return null;
    }
  }
}
