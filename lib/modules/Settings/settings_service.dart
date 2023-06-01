import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../config/config.dart';
import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';

var client = http.Client();

class SettingsService {
  Future<void> modifierProfile(File imageFile, String api, String nom,
      String prenom, String email, String numTel, String password) async {
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
      request.fields['nom'] = nom;
      request.fields['prenom'] = prenom;
      request.fields['email'] = email;
      request.fields['numTel'] = numTel;
      request.fields['password'] = password;

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
