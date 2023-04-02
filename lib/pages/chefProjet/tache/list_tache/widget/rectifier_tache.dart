import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/list_tache/widget/tache_card.dart';
import '../../../../../models/tache.dart';

class RectifierTache extends StatefulWidget {
  List<Tache> taches;
  RectifierTache({super.key, required this.taches});

  @override
  State<RectifierTache> createState() => _RectifierTacheState();
}

class _RectifierTacheState extends State<RectifierTache> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tache> taches = [];
    for (Tache tache in widget.taches) {
      if (tache.type == "rectification") {
        taches.add(tache);
      }
    }

    ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "tâches à rectifier",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              ),
              Text(
                "Total tâches: ${taches.length}",
                style: themeData.textTheme.caption,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
              child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return TacheCard(
                tache: taches[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.0,
              );
            },
            itemCount: taches.length,
          )),
        ],
      ),
    );
  }
}
