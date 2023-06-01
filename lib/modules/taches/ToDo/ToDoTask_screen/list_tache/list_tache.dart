import 'dart:core';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/taches/ToDo/ToDoTask_screen/list_tache/widget/nouveau_tache.dart';
import 'package:mastech/modules/taches/ToDo/ToDoTask_screen/list_tache/widget/rectifier_tache.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../models/tache.dart';
import '../../../affected/affectedTask_screen/list_tache/widget/total_tache.dart';
import '../../../affectedTask_controller.dart';

class ListTache extends StatefulWidget {
  const ListTache({super.key});
  @override
  State<ListTache> createState() => _ListTacheState();
}

class _ListTacheState extends State<ListTache> {
  final AffectedTaskController taskController =
      Get.put(AffectedTaskController());

  late SharedPreferences _prefs;
  List? _dataFromFiltre;
  final _searchController = TextEditingController();
  List<Tache> taches = [];
  late List<Tache> displayList = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _RemoveStorageData() async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove('sortedStorage');
    await _prefs.remove('etatRectificationStorage');
    await _prefs.remove('etatNouveauStorage');
    setState(() {});
  }

  void openFilterDialog(context) async {
    print(taskController.selectedFiltres);
    await FilterListDialog.display<String>(
      context,
      listData: taskController.listChoise,
      selectedListData: taskController.selectedFiltres,
      choiceChipLabel: (chois) => chois,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (chois, query) {
        return chois.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          taskController.selectedFiltres.value = List.from(list!);
        });
        Navigator.pop(context);
        taskController.filtreTask();
      },
    );
  }

  void _search(String value) {
    List<Tache> results = [];
    results = taskController.tachesList
        .where((element) =>
            element.titre!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      taskController.displayList.value = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // before the user leaves the page.
          _RemoveStorageData();
          return true; // Return true to allow the user to leave the page.
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              taskController.chantier.value.nom ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 10.0,
              ),
            ),

            // systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SingleChildScrollView(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        _search(value);
                      },
                      controller: _searchController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Rechercher une tâche",
                      ),
                    ),
                  ),
                  Container(
                    height: 72,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              openFilterDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.filter_list, color: Colors.white),
                                  Text("Filtre",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  TotalTache(totalTache: taskController.displayList.length),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Color.fromRGBO(97, 99, 119, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  NouveauTache(taches: taskController.displayList),
                  RectifierTache(taches: taskController.displayList),
                ],
              ),
            ),
          ),
        ));
  }
}
