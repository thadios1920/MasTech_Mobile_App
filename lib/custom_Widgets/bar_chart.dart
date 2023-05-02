import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/models/chantier.dart';

class BarChart extends StatelessWidget {
  final List<double> stats;
  final List<Chantier> chantierList;

  const BarChart(this.stats, this.chantierList,
      {super.key}); // Correction de la syntaxe du constructeur

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 0;
    for (var price in stats) {
      if (price > mostExpensive) {
        mostExpensive = price;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Statistiques hebdomadaires',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30.0,
                onPressed: () {},
              ),
              const Flexible(
                child: Text(
                  'Nov 10, 2019 - Nov 16, 2019',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Bar(
                label: 'Estim',
                amountSpent: stats[0],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Elab',
                amountSpent: stats[1],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Fab',
                amountSpent: stats[2],
                mostExpensive: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;

  final double _maxBarHeight = 150.0;

  const Bar(
      {super.key,
      required this.label,
      required this.amountSpent,
      required this.mostExpensive});

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Column(
      children: <Widget>[
        Text(
          '%${amountSpent.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 18.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
