import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/taches/ToDo/ToDoTask_screen/tache_detail/tache_detail.dart';
import '../../../../../../models/tache.dart';
import '../../../../affectedTask_controller.dart';

class TacheCard extends StatefulWidget {
  final Tache tache;
  TacheCard({super.key, required this.tache});

  @override
  State<TacheCard> createState() => _TacheCardState();
}

class _TacheCardState extends State<TacheCard> {
  final AffectedTaskController affectedTaskController =
      Get.put(AffectedTaskController());
  @override
  Widget build(BuildContext context) {
    Tache tache = widget.tache;
    ThemeData themeData = Theme.of(context);
    final titleLengthLimit = 10; // Limite de la longueur du titre

    String getTitleText() {
      if (tache.titre!.length <= titleLengthLimit) {
        return tache.titre ?? "";
      } else {
        return '${tache.titre!.substring(0, titleLengthLimit)}...';
      }
    }

    String getDateFin() {
      if (tache.dateFin!.length <= titleLengthLimit) {
        return tache.dateFin ?? "";
      } else {
        return '${tache.dateFin!.substring(0, titleLengthLimit)}...';
      }
    }

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          color: const Color.fromRGBO(97, 201, 200, 1),
          icon: Icons.done,
          foregroundColor: Colors.white,
          onTap: () async {
            affectedTaskController.terminerTask(widget.tache.id!);
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
              const SizedBox(width: 40.0, child: Icon(Icons.add_alert)),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTitleText(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    getDateFin(),
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
                  const Text(
                    "Date Fin:",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
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
                                ? const Color.fromRGBO(247, 71, 104, 1)
                                : const Color.fromRGBO(97, 201, 200, 1),
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
