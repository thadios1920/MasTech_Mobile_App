import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../models/tache.dart';

class Tacheheader extends StatefulWidget {
  final Tache tache;
  Tacheheader({required this.tache});

  @override
  State<Tacheheader> createState() => _TacheheaderState();
}

class _TacheheaderState extends State<Tacheheader> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Tache tache = widget.tache;
    DateTime dateCreated = DateTime.parse(tache.createdAt!);
    String formattedDateCreated =
        DateFormat('yyyy-MM-dd – kk:mm').format(dateCreated);
    DateTime dateLimite = DateTime.parse(tache.dateFin!);
    String formattedDateFin =
        DateFormat('yyyy-MM-dd – kk:mm').format(dateLimite);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Crée le :  ",
                style: themeData.textTheme.bodySmall,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                formattedDateCreated,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date limite :",
                style: themeData.textTheme.bodySmall,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                formattedDateFin,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
