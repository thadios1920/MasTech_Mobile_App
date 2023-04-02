import 'package:flutter/material.dart';

import '../../../../../models/tache.dart';
class TacheDescription extends StatefulWidget {
  final Tache tache;
  TacheDescription({required this.tache});

  @override
  State<TacheDescription> createState() => _TacheDescriptionState();
}

class _TacheDescriptionState extends State<TacheDescription> {
  @override
  Widget build(BuildContext context) {
    Tache tache = widget.tache;

    ThemeData themeData = Theme.of(context);
    return Container(
      height:  90.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chef Projet",
                  style: themeData.textTheme.caption,

                ),
                SizedBox(
                  height: 8.0,
                ),

                  Text(
                    "Terminer",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight:FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),

              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Type",
                style: themeData.textTheme.caption,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "${tache.type}",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight:FontWeight.w400,
                  color: tache.type == "rectification"
                      ? Color.fromRGBO(247, 71, 104, 1)
                      : Color.fromRGBO(97, 201, 200, 1),
                ),
              ),
            ],
          )
        ],


      ),
    );
  }
}
