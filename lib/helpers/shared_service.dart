import 'dart:convert';

import 'package:mastech/models/login_details.dart';
import 'package:mastech/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  setLoginDetails(LoginDetails details) async {
    final SharedPreferences prefs = await _prefs;
    final detailsJson = json.encode(details.toJson());
    await prefs.setString('Login_details', detailsJson);
  }

  Future<LoginDetails> getLoginDetails() async {
    final SharedPreferences prefs = await _prefs;
    final json = prefs.getString('Login_details');

    return LoginDetails.fromJson(jsonDecode(json!));
  }

  Future<Utilisateur> getUserDetails() async {
    final SharedPreferences prefs = await _prefs;
    final json = prefs.getString('Login_details');

    var details = LoginDetails.fromJson(jsonDecode(json!));

    return details.user!;
  }

  deleteLoginDetails() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('Login_details');
  }
}
