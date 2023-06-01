import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/bar_chart.dart';
import '../../custom_widgets/radial_painter.dart';
import '../taches/ToDo/ToDoTask_screen/list_tache/list_tache.dart';
import '../taches/affectedTask_bindings.dart';
import 'chantier_chefProjet_controller.dart';

class ListChantierChefChantier extends StatefulWidget {
  const ListChantierChefChantier({super.key});

  @override
  State<ListChantierChefChantier> createState() =>
      _ListChantierChefChantierState();
}

class _ListChantierChefChantierState extends State<ListChantierChefChantier> {
  final ChantierController chantierController = Get.put(ChantierController());
  _buildChantiers() {
    List<Widget> chantierList = [];
    for (var chantier in chantierController.chantiersList) {
      chantierList.add(GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => ListTache(chantier: chantier)),
            // );
            Get.to(const ListTache(),
                arguments: chantier, binding: AffectedTaskBindings());
          },
          child: Container(
            alignment: Alignment.center,
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            height: 80.0,
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
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Chantier :${chantier.nom!}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    chantier.categorie!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )));
    }
    return Column(
      children: chantierList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (chantierController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (chantierController.chantiersList.isEmpty) {
          return const Center(
            child: Text(
              'Aucun chantier disponible',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        } else {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        margin:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: BarChart(chantierController.chantiersList),
                      );
                    } else {
                      return _buildChantiers();
                    }
                  },
                  childCount: 1 + chantierController.chantiersList.length,
                ),
              ),
            ],
          );
        }
      }
    });
  }
}
