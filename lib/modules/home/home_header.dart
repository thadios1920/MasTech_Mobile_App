import 'package:flutter/material.dart';
import 'package:mastech/models/utilisateur.dart';

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  Utilisateur user = Utilisateur();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    LoginDetails details = await SharedService().getLoginDetails();
    user = details.user!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[800],
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(user.imageURL ?? ""),
              ),
            ),
          ),
          Text(
            user.nom ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            user.email ?? "",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
