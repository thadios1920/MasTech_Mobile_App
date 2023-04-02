import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/models/projet.dart';
import 'package:pfe_mobile_app/pages/chefProjet/list-etage.dart';

import '../../custom_Widgets/radial_painter.dart';
import '../../helpers/color_helper.dart';
import '../../models/chantier.dart';
import '../../services/api_Client.dart';

class ChantierDetails extends StatefulWidget {
  final Chantier chantier;
  const ChantierDetails({super.key, required this.chantier});

  @override
  _ChantierDetailsState createState() => _ChantierDetailsState();
}

class _ChantierDetailsState extends State<ChantierDetails> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    // id = widget.projet.id.toString();
    // getProjets();
  }

  // _buildChantiers() {
  //   List<Widget> expenseList = [];
  //   for (var chantier in chantiersList) {
  //     expenseList.add(GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ListEtage(chantier: chantier)),
  //           );
  //         },
  //         child: Container(
  //           alignment: Alignment.center,
  //           margin:
  //               const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //           height: 80.0,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10.0),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 offset: Offset(0, 2),
  //                 blurRadius: 6.0,
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(30.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 Text(
  //                   chantier.nom!,
  //                   style: const TextStyle(
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Text(
  //                   'n°:${chantier.id}',
  //                   style: const TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )));
  //   }
  //   return Column(
  //     children: expenseList,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // double totalAmountSpent = 0;
    // chantiersList.forEach((Chantier chantier) {
    //   totalAmountSpent += 1;
    // });
    // final double amountLeft = widget.category.maxAmount - totalAmountSpent;
    final double percent = 20;

    List<Widget> expenseList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chantier.nom!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              height: 250.0,
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
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: Colors.grey,
                  lineColor: getColor(context, 20),
                  percent: percent,
                  width: 15.0,
                ),
                child: const Center(
                  child: Text(
                    "10%",
                    // '\$${amountLeft.toStringAsFixed(2)} / \$${widget.category.maxAmount}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // ListEtage(chantier: widget.chantier)
          ],
        ),
      ),
    );
  }
}
