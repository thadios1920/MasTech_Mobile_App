import 'dart:convert';

import 'package:mastech/config/config.dart';
import 'package:mastech/helpers/shared_service.dart';
import '../../models/chantier.dart';
import 'package:http/http.dart' as http;

import '../../models/login_details.dart';

var client = http.Client();

class ChantierService {
  // GET method retourne les projet du chef projet inscrit
  static Future<List<Chantier>> getChantiers(String api) async {
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
        return Chantier.chantierFromJSON(tempList);
      } else {
        throw Exception('Failed to load chantiers');
      }
    } catch (e) {
      throw Exception('Failed to load chantiers');
    }
  }
}
