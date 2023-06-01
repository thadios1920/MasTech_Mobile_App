import 'package:flutter/material.dart';

class TotalTache extends StatefulWidget {
  final int totalTache;

  const TotalTache({super.key, required this.totalTache});

  @override
  State<TotalTache> createState() => _TotalTacheState();
}

class _TotalTacheState extends State<TotalTache> {
  @override
  Widget build(BuildContext context) {
    int totalTache = widget.totalTache;
    ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total tâches",
            style: themeData.textTheme.bodySmall,
          ),
          const SizedBox(
            height: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$totalTache",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 26.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
