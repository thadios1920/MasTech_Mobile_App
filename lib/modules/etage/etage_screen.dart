import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/etage/etage_controller.dart';

import '../../custom_widgets/posts_carousel.dart';
import '../../custom_widgets/radial_painter.dart';
import '../../helpers/pdf_service.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

import '../taches/affected/affectedTask_screen/list_tache/list_tache.dart';

class ListEtage extends StatefulWidget {
  const ListEtage();

  @override
  State<ListEtage> createState() => _ListEtageState();
}

class _ListEtageState extends State<ListEtage>
    with SingleTickerProviderStateMixin {
  final EtageController etageController = Get.put(EtageController());
  // final chantier = Get.arguments;

  int _currentIndex = 0;
  late TabController _tabController;
  late PageController _pageController;
  late bool isProjectClosed = etageController.chantier.value
      .etat!; // en peut auusi utiliser chantier de Get.argument variable indiquant si le projet est clôturé ou non

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  _buildListEtage() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          etageController.chantier.value.nom ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0,
          ),
        ),

        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // drawer: CustomDrawer(),
      body: [
        ListView(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    height: 200.0,
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
                        // lineColor: getColor(context, percentAV),
                        // percent: percentAV / 100,

                        lineColors: const [
                          Colors.blue,
                          Colors.red,
                          Colors.green
                        ],
                        values: [
                          etageController.chantier.value.percentEstimation!
                              .toDouble(),
                          etageController.chantier.value.percentElaboration!
                              .toDouble(),
                          etageController.chantier.value.percentFabrication!
                              .toDouble()
                        ],
                        width: 15.0,
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            "${etageController.chantier.value.percentAvancement}%",
                            // '\$${amountLeft.toStringAsFixed(2)} / \$${widget.category.maxAmount}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PostsCarousel(
              pageController: _pageController,
              title: 'Etages',
              etages: etageController.etagesList,
              plans: etageController.planList,
            ),
            Center(
              child: isProjectClosed
                  ? OutlineGradientButton(
                      gradient: const LinearGradient(
                          colors: [Colors.greenAccent, Colors.yellow]),
                      strokeWidth: 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      corners: const Corners(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      backgroundColor: Colors.lightBlue,
                      elevation: 4,
                      inkWell: true,
                      onTap: () => PdfService.openFile(
                          url:
                              'http://192.168.1.12:8080/api/v1/chefProjets/generate-rapport',
                          fileName:
                              'rapport-${etageController.chantier.value.nom}'),
                      child: const Text('Générer Rapport',
                          style: TextStyle(color: Colors.white, fontSize: 12)))
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OutlineGradientButton(
                        gradient: const LinearGradient(
                            colors: [Colors.pink, Colors.purple]),
                        strokeWidth: 4,
                        radius: const Radius.circular(8),
                        onTap: () {
                          setState(() {
                            isProjectClosed = true;
                          });
                        },
                        child: const Text('Clôturer le chantier'),
                      ),
                    ),
            ),
          ],
        ),
        ListTache(
          idChantier: etageController.chantier.value.id.toString(),
        )
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setCurrentIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics_rounded), label: "Plans"),
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rtl), label: "Taches"),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildListEtage();
  }
}
