import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/chantier/list_chantier_chefChantier_screen.dart';

import 'package:mastech/modules/sign_in/sign_in_controller.dart';

import '../../config/config.dart';
import '../Settings/settings_screen.dart';
import '../chantier/list_chantier_chefProjet_screen.dart';
import 'home_controller.dart';
import 'home_header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage = DrawerSections.dashboard;
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var container;
        if (currentPage == DrawerSections.dashboard) {
          container = homeController.isChefProjet.value
              ? const ListChantierChefProjet()
              : const ListChantierChefChantier();
        } else if (currentPage == DrawerSections.logout) {
          SignInController.logout(context);
          // Retournez une Widget vide lorsque vous vous déconnectez
          return Container();
        } else if (currentPage == DrawerSections.settings) {
          container = ProfileEditPage();
        }
        return WillPopScope(
          // Utilisez WillPopScope pour gérer la navigation arrière
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo[800],
              title: const Text(Config.appName),
            ),
            body: container,
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const HomeHeader(),
                    DrawerList(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget DrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Chantiers", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Taches", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "Events", Icons.event,
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Notes", Icons.notes,
              currentPage == DrawerSections.notes ? true : false),
          const Divider(),
          menuItem(5, "Mon compte", Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false),
          menuItem(6, "Notifications", Icons.notifications_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          const Divider(),
          menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(8, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
          menuItem(9, "Deconnexion", Icons.logout,
              currentPage == DrawerSections.logout ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            } else if (id == 9) {
              currentPage = DrawerSections.logout;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  notes,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
  logout
}
