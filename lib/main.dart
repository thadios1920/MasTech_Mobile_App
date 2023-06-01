import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/home/home_screen.dart';
import 'package:mastech/modules/sign_in/sign_in_bindings.dart';
import 'package:mastech/modules/sign_in/sign_in_screen.dart';

void main() {
  runApp(const MasTech());
}

class MasTech extends StatelessWidget {
  const MasTech({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.indigo,
      initialRoute: '/login',
      getPages: [
        GetPage(
            name: '/login',
            page: () => const LoginScreen(),
            binding: SignInBindings()),
        GetPage(name: '/home', page: () => const Home())
      ],
    );
  }
}
