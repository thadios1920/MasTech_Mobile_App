import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/list_tache/list_tache.dart';
import '../../custom_Widgets/radial_painter.dart';
import '../../helpers/color_helper.dart';
import '../../models/chantier.dart';
import '../../services/api_Client.dart';

class ListChantier extends StatefulWidget {
  const ListChantier({super.key});

  @override
  _ListChantierState createState() => _ListChantierState();
}

class _ListChantierState extends State<ListChantier> {
  List<Chantier> chantiersList = [];
  String id = "";
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getProjets();
  }

  Future<void> getProjets() async {
    chantiersList = await ApiClient.getChantiers("/chefChantiers/1/chantiers");
    setState(() {});

    if (chantiersList.isNotEmpty) {
      isLoaded = true;
    }
  }

  _buildChantiers() {
    List<Widget> expenseList = [];
    chantiersList.forEach((Chantier chantier) {
      expenseList.add(GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListTache(chantier: chantier)),
            );
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
                    "Chantier :" + chantier.nom!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'n°:${chantier.id}',
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
    });
    return Column(
      children: expenseList,
    );
  }

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
                  // bgColor: Colors.grey,
                  // lineColor: getColor(context, 20),
                  // percent: percent,
                  bgColor: Colors.grey,
                  lineColors: [Colors.blue, Colors.red, Colors.green],
                  values: [20, 50, 30],
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
            _buildChantiers(),
          ],
        ),
      ),
    );
  }
}
