import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mastech/models/utilisateur.dart';

import '../../../config/config.dart';
import '../../../helpers/shared_service.dart';
import '../../../models/login_details.dart';
import '../../../models/tache.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

var client = http.Client();

class AffectedTaskService {
  static Future<Tache> ajouterTache(String api, Tache task) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(task),
    );

    if (response.statusCode == 201) {
      // Si la création est réussie, retourne la tâche créée
      return Tache.fromJson(jsonDecode(response.body));
    } else {
      // Si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to create task.');
    }
  }

  static Future<List<Tache>> getTaches(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    });

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Tache.tacheFromJSON(tempList);
  }

  static modifierTache(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    });

    if (response.statusCode == 200) {
      // si la création est réussie, retourne la tâche créée
      return jsonDecode(response.body);
    } else {
      // si la création a échoué, lève une exception avec le message d'erreur
      throw Exception('Failed to update task.');
    }
  }

  static supprimmerTache(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
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

  static Future<void> rectifierTache(
      File imageFile, String api, String description) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse(Config.baseURL + api));
      LoginDetails details = await SharedService().getLoginDetails();
      String token = details.token!;
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Authorization': token,
      });
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      request.fields['description'] = description;

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Image upload failed. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // GET method retourne les projet du chef projet inscrit
  static Future<List<Utilisateur>> getChefChantier(String api) async {
    var url = Uri.parse(Config.baseURL + api);
    LoginDetails details = await SharedService().getLoginDetails();
    String token = details.token!;
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    // print("response ${jsonDecode(response.body)}");

    var data = jsonDecode(response.body);
    List tempList = [];
    for (var v in data) {
      tempList.add(v);
    }
    return Utilisateur.chefChnatierFromJSON(tempList);
  }
}
