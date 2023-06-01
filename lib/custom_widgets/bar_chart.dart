import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import '../models/chantier.dart';

class BarChart extends StatefulWidget {
  final List<Chantier> chantierList;

  const BarChart(this.chantierList, {super.key});

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  int? _currentChantierIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.chantierList[_currentChantierIndex!].nom ?? "",
            style: const TextStyle(
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
                onPressed: () {
                  setState(() {
                    _currentChantierIndex = (_currentChantierIndex! - 1) %
                        widget.chantierList.length;
                  });
                },
              ),
              Flexible(
                child: Text(
                  'Date Fin :${widget.chantierList[_currentChantierIndex!].dateFin!.format(DateTimeFormats.europeanAbbr).toString()}',
                  // 'Nov 10, 2019 - Nov 16, 2019',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 30.0,
                onPressed: () {
                  setState(() {
                    _currentChantierIndex = (_currentChantierIndex! + 1) %
                        widget.chantierList.length;
                  });
                },
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
                statValeur: widget
                    .chantierList[_currentChantierIndex!].percentEstimation!
                    .toDouble(),
              ),
              Bar(
                label: 'Elab',
                statValeur: widget
                    .chantierList[_currentChantierIndex!].percentElaboration!
                    .toDouble(),
              ),
              Bar(
                label: 'Fab',
                statValeur: widget
                    .chantierList[_currentChantierIndex!].percentFabrication!
                    .toDouble(),
              ),
              Bar(
                label: 'Av',
                statValeur: widget
                    .chantierList[_currentChantierIndex!].percentAvancement!
                    .toDouble(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double statValeur;

  final double _maxBarHeight = 150.0;

  const Bar({
    Key? key,
    required this.label,
    required this.statValeur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barHeight = statValeur / 100 * _maxBarHeight;
    final mq = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Text(
          '%${statValeur.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: mq.textScaleFactor * 16.0,
          ),
        ),
        SizedBox(height: mq.size.height * 0.01),
        Container(
          height: barHeight,
          width: mq.size.width * 0.04,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(mq.size.width * 0.01),
          ),
        ),
        SizedBox(height: mq.size.height * 0.02),
        Text(
          label,
          style: TextStyle(
            fontSize: mq.textScaleFactor * 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
