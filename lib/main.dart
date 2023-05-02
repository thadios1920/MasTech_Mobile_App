import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/chefChantierHome.dart';
import 'package:pfe_mobile_app/pages/forgot_password.dart';
import 'package:pfe_mobile_app/pages/login_page.dart';
import 'package:pfe_mobile_app/services/helpers/shared_service.dart';

import 'pages/chefProjet/chefProjetHome.dart';

Widget _defaultHome = LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = const ChefProjetHome();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAS',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // home: const Scaffold(
      //   body: ChefProjetHome(),
      // ),
      routes: {
        '/': (context) => _defaultHome,
        '/chefProjet': (context) => const ChefProjetHome(),
        '/chefChantier': (context) => const ChefChantierHome(),
        '/forgot': (context) => const ForgotPassword(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
