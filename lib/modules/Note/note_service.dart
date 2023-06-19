import 'dart:convert';

import 'package:mastech/config/config.dart';
import 'package:mastech/helpers/shared_service.dart';
import 'package:mastech/models/etage.dart';
import 'package:http/http.dart' as http;

import '../../models/login_details.dart';

var client = http.Client();

class NoteService {
  // GET method retourne les etages du chef projet inscrit
  static Future<dynamic> getNote(String api) async {
    try {
      var url = Uri.parse(Config.baseURL + api);
      LoginDetails details = await SharedService().getLoginDetails();
      String token = details.token!;
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );

      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load notes');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load notes');
    }
  }

  Future<void> modifierNote(String api, String note) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse(Config.baseURL + api));
      LoginDetails details = await SharedService().getLoginDetails();
      String token = details.token!;
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Authorization': token,
      });

      request.fields['note'] = note;

      var response = await request.send();
      if (response.statusCode == 200) {
        print('note uploaded successfully!');
      } else {
        print('failed. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error : $e');
    }
  }
}
