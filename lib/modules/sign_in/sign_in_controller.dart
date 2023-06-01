import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mastech/config/config.dart';
import 'package:mastech/helpers/shared_service.dart';
import 'package:mastech/models/login_details.dart';

var client = http.Client();

class SignInController extends GetxController {
  var loginProcess = false.obs;

  Future<bool> login(String cin, String password) async {
    try {
      var url = Uri.parse("http://192.168.1.12:8080/api/v1/auth/login");
      print(url);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cin': cin, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        await SharedService()
            .setLoginDetails(LoginDetails.fromJson(jsonResponse));

        loginProcess(true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // throw Exception('Authentification echouée');
      print(e);
      throw Exception(e);
    }
  }

  static Future<void> logout(BuildContext context) async {
    await SharedService().deleteLoginDetails();
    Get.offAllNamed('/login');
  }
}
