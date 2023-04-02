import 'package:flutter/material.dart';

class ChefProjetHeader extends StatefulWidget {
  const ChefProjetHeader({super.key});

  @override
  State<ChefProjetHeader> createState() => _ChefProjetHeaderState();
}

class _ChefProjetHeaderState extends State<ChefProjetHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[800],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/user0.jpg'),
              ),
            ),
          ),
          Text(
            "Chef 1",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "info@rapidtech.dev",
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
