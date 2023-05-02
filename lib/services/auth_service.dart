import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_mobile_app/models/chefProjet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/config.dart';
import 'helpers/shared_service.dart';

var client = http.Client();

class AuthService {
  static Future<bool> login(String cin, String password) async {
    try {
      var url = Uri.http(Config.apiURL, Config.loginApi + '/chefProjet');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cin': cin, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // prefs.setString('jwt', jsonResponse['token']);
        await SharedService.setUserDetails(jsonResponse['user']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // throw Exception('Authentification echouée');
      throw Exception(e);
    }
  }

// Methode qui retourne les données du user
  static Future<ChefProjet?> getUserProfile() async {
    try {
      var loginDetails = await SharedService.userDetails();

      var url = Uri.http(Config.apiURL, Config.userProfileApi);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${loginDetails!.id}' //ici j'ai mis id pour le mment mais il faus faire loginResponse class
        },
      );

      if (response.statusCode == 200) {
        return ChefProjet.chefFromJSON(jsonDecode(response.body));
      }
    } catch (e) {
      // throw Exception('Authentification echouée');
      throw Exception(e);
    }
  }

  static Future<void> logout(BuildContext context) async {
    await SharedService.deleteUserDetails();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
