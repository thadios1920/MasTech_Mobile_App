import 'package:flutter/material.dart';

class ChantierItem extends StatelessWidget {
  final String nom;
  final String description;
  final VoidCallback onTap;

  const ChantierItem({
    super.key,
    required this.nom,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(nom),
        subtitle: Text(description),
        onTap: () => onTap(),
      ),
    );
  }
}
