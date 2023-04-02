import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/list_tache/widget/tache_card.dart';
import '../../../../../models/tache.dart';

class NouveauTache extends StatefulWidget {
  List<Tache> taches;
   NouveauTache({super.key,required this.taches});

  @override
  State<NouveauTache> createState() => _NouveauTacheState();
}

class _NouveauTacheState extends State<NouveauTache> {


  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    List<Tache> taches = [];
    for (Tache tache in widget.taches) {
      if (tache.type=="nouveau")
        taches.add(tache);
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
                "nouveaux tâches",
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
          ListView.separated(
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
            itemCount:  taches.length,
          )
        ],
      ),
    );
  }
}
