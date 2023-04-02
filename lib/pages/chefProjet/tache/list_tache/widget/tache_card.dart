import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../models/chefChantier.dart';
import '../../../../../models/tache.dart';
import '../../../../../services/api_Client.dart';
import '../../tache_detail/tache_detail.dart';

class TacheCard extends StatefulWidget {
  final Tache tache;
  TacheCard({super.key, required this.tache});

  @override
  State<TacheCard> createState() => _TacheCardState();
}

class _TacheCardState extends State<TacheCard> {
  ChefChantier chefChantier = ChefChantier();
  Future<void> _updateTask(Tache tache, int idTask) async {
    await ApiClient.modifierTache('/taches/$idTask', tache);
    setState(() {});
  }

  Future<void> _deleteTask(int idTask) async {
    await ApiClient.supprimmerTache('/taches/$idTask');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tache tache = widget.tache;
    ThemeData themeData = Theme.of(context);
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          color: const Color.fromRGBO(247, 71, 104, 1),
          icon: Icons.delete_forever,
          foregroundColor: Colors.white,
          onTap: () {
            _deleteTask(widget.tache.id!);
            setState(() {});
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: const Color.fromRGBO(97, 201, 200, 1),
          icon: Icons.done_outlined,
          foregroundColor: Colors.white,
          onTap: () async {
            Tache tache = Tache(
                titre: widget.tache.titre,
                description: widget.tache.description,
                type: widget.tache.type,
                statut: true,
                etat: widget.tache.etat);
            await _updateTask(tache, widget.tache.id!);
            setState(() {});
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return TacheDetail(tache: tache);
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.all(20.0),
          height: 100.0,
          width: double.infinity,
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
          child: Row(
            children: [
              SizedBox(
                  width: 40.0,
                  child: widget.tache.type == "rectification"
                      ? const Icon(
                          Icons.add_alert_sharp,
                          color: Colors.red,
                        )
                      : const Icon(Icons.add_alert_sharp)),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${tache.titre}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Chef Chantier:${tache.chefChantierId}",
                    style:
                        themeData.textTheme.bodySmall?.copyWith(fontSize: 14.0),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (tache.etat == true)
                    const Text(
                      "Terminée",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                    ),
                  if (tache.etat == false)
                    const Text(
                      "En cours...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                    ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "${tache.type}",
                        style: TextStyle(
                            color: tache.type == "rectification"
                                ? Color.fromRGBO(247, 71, 104, 1)
                                : Color.fromRGBO(97, 201, 200, 1),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400),
                      ),
                      /*Icon(

                      )*/
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
