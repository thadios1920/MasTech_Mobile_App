import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/bar_chart.dart';
import '../../models/chantier.dart';
import '../etage/etage_screen.dart';
import 'chantier_chefProjet_controller.dart';

class ListChantierChefProjet extends StatefulWidget {
  const ListChantierChefProjet({super.key});

  @override
  State<ListChantierChefProjet> createState() => _ListChantierChefProjetState();
}

class _ListChantierChefProjetState extends State<ListChantierChefProjet> {
  final ChantierController chantierController = Get.put(ChantierController());

  _buildChantier(Chantier chantier) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListEtage(chantier: chantier),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  chantier.nom!,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  chantier.lieu!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                chantier.etat!
                    ? const Icon(
                        Icons.done_outline_rounded,
                        color: Colors.green,
                      )
                    : const SizedBox()
              ],
            ),
            const SizedBox(height: 10.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                double percent = chantier.percentAvancement!
                    .toDouble(); // ici en affecte le pourcentage d'avancement du chantier

                double barWidth = maxBarWidth * percent / 100;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: barWidth,
                      decoration: BoxDecoration(
                        // color: getColor(context, percent),
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
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
        return CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
                    final Chantier chantier =
                        chantierController.chantiersList[index - 1];

                    return _buildChantier(chantier);
                  }
                },
                childCount: 1 + chantierController.chantiersList.length,
              ),
            ),
          ],
        );
      }
    });
  }
}
