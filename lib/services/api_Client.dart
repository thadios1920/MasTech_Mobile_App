import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/chantier.dart';
import '../models/chefChantier.dart';
import '../models/etage.dart';
import '../models/projet.dart';
import '../models/element.dart' as element;
import '../models/tache.dart';
import '../models/zone.dart';

var client = http.Client();
const String baseUrl = "http://192.168.1.12:8080/api/v1";

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

  static Future<Tache> ajouterTache(String api, Tache task) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  static modifierTache(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

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

  static affecterElement(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

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

  static Future<void> rectifierTache(
      File imageFile, String api, String description) async {
    try {
      // Convertir le fichier en Image
      final bytes = await imageFile.readAsBytes();
      ui.Image image = await decodeImageFromList(bytes);

      // Créer une nouvelle image de la même taille avec une couleur blanche
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(Colors.white, BlendMode.color);
      canvas.drawImage(image, Offset.zero, Paint());

      // Convertir l'image en un ByteData
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);

      // Vérifier que l'image est bien au format PNG
      final pngBytes = await img.toByteData(format: ImageByteFormat.png);
      if (pngBytes == null) {
        print('Error: could not convert image to PNG format');
        return;
      }

      // Convertir ByteData en Uint8List
      final uint8List = pngBytes.buffer.asUint8List();
      print('Type of image: ${pngBytes.runtimeType}');

      // Envoyer la requête HTTP avec l'image convertie
      var request = http.MultipartRequest('PUT', Uri.parse(baseUrl + api));
      request.files.add(http.MultipartFile.fromBytes('image', uint8List,
          filename: 'image.png'));
      request.fields['description'] = description;

      print("${request}");
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
}
