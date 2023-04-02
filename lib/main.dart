import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/chefChantierHome.dart';
import 'package:pfe_mobile_app/pages/chefProjet/chefProjetHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAS',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // theme: ThemeData(primaryColor: const Color(0xFF334a5c)),
      home: const Scaffold(
        body: ChefChantierHome(),
      ),
    );
  }
}
