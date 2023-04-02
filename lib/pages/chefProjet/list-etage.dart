import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/image.dart';
import 'package:pfe_mobile_app/models/chantier.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/list_tache/list_tache.dart';
import 'package:pfe_mobile_app/pages/chefProjet/taskListPage.dart';
import '../../custom_Widgets/radial_painter.dart';
import '../../helpers/color_helper.dart';
import '../../models/element.dart' as element;

import '../../custom_Widgets/posts_carousel.dart';
import '../../models/etage.dart';
import '../../services/api_Client.dart';

class ListEtage extends StatefulWidget {
  final Chantier chantier;
  const ListEtage({super.key, required this.chantier});

  @override
  State<ListEtage> createState() => _ListEtageState();
}

class _ListEtageState extends State<ListEtage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  late PageController _pageController;

  List<Etage> etagesList = [];
  List planList = [];

  String id = "";
  var isLoaded = false;
  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    id = widget.chantier.id.toString();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    getEtages();
  }

  Future<void> getEtages() async {
    etagesList = await ApiClient.getEtages("/chantiers/$id/etages");

    if (etagesList.isNotEmpty) {
      await getPlans();
      // await getElements();
      setState(() {});
    }
  }

  Future<void> getPlans() async {
    try {
      for (var i = 0; i < etagesList.length; i++) {
        var plan = await ApiClient.getPlan("/etages/${etagesList[i].id}/plan");
        setState(() {
          planList.add(plan);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _buildListEtage() {
    final double percent = 0.25;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.chantier.nom ?? "",
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
                        lineColor: getColor(context, percent),
                        percent: percent,
                        width: 15.0,
                      ),
                      child: Center(
                        child: Text(
                          "${widget.chantier.percentAvancement}%",
                          // '\$${amountLeft.toStringAsFixed(2)} / \$${widget.category.maxAmount}',
                          style: const TextStyle(
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
            PostsCarousel(
              pageController: _pageController,
              title: 'Etages',
              etages: etagesList,
              plans: planList,
            ),
          ],
        ),
        ListTache(
          idChantier: widget.chantier.id.toString(),
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
