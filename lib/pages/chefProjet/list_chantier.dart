import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefProjet/list-etage.dart';

import '../../custom_Widgets/bar_chart.dart';
import '../../helpers/color_helper.dart';
import '../../models/chantier.dart';
import '../../services/api_Client.dart';
import 'chantierDetails.dart';

class ListChantier extends StatefulWidget {
  const ListChantier({super.key});

  @override
  _ListChantierState createState() => _ListChantierState();
}

class _ListChantierState extends State<ListChantier> {
  List<Chantier> chantiers = [];
  var isLoaded = false;
  @override
  void initState() {
    super.initState();

    getChantiers();
  }

  Future<void> getChantiers() async {
    chantiers = await ApiClient.getChantiers('/chefprojets/1/chantiers');
    setState(() {});

    if (chantiers.isNotEmpty) {
      isLoaded = true;
    }
  }

  final List<double> weeklySpending = [10, 15, 25, 14, 45, 12, 78];

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
                  '${chantier.lieu}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = 10;
                const double percent =
                    0.25; // ici en affecte le pourcentage d'avancement du chantier

                double barWidth = 10 * maxBarWidth;

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
                        color: getColor(context, percent),
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
    return Container(
      child: CustomScrollView(
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
                    child: BarChart(weeklySpending),
                  );
                } else {
                  final Chantier chantier = chantiers[index - 1];

                  return _buildChantier(chantier);
                }
              },
              childCount: 1 + chantiers.length,
            ),
          ),
        ],
      ),
    );
  }
}
