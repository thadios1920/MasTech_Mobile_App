import 'dart:core';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/taches/affectedTask_bindings.dart';
import 'package:mastech/modules/taches/affected/affectedTask_screen/list_tache/widget/nouveau_tache.dart';
import 'package:mastech/modules/taches/affected/affectedTask_screen/list_tache/widget/rectifier_tache.dart';
import 'package:mastech/modules/taches/affected/affectedTask_screen/list_tache/widget/total_tache.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../models/tache.dart';
import '../../../affectedTask_controller.dart';
import '../../../createTask_screen.dart';

class ListTache extends StatefulWidget {
  final idChantier;
  const ListTache({super.key, required this.idChantier});
  @override
  State<ListTache> createState() => _ListTacheState();
}

class _ListTacheState extends State<ListTache> {
  final AffectedTaskController affectedTaskController =
      Get.put(AffectedTaskController());
  late SharedPreferences _prefs;
  List? _dataFromFiltre;
  final _searchController = TextEditingController();

  Future<void> _RemoveStorageData() async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove('sortedStorage');
    await _prefs.remove('etatRectificationStorage');
    await _prefs.remove('etatNouveauStorage');
    setState(() {});
  }

  void openFilterDialog(context) async {
    print(affectedTaskController.selectedFiltres);
    await FilterListDialog.display<String>(
      context,
      listData: affectedTaskController.listChoise,
      selectedListData: affectedTaskController.selectedFiltres,
      choiceChipLabel: (chois) => chois,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (chois, query) {
        return chois.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          affectedTaskController.selectedFiltres.value = List.from(list!);
        });
        Navigator.pop(context);
        affectedTaskController.filtreTask();
      },
    );
  }

  void _search(String value) {
    List<Tache> results = [];
    results = affectedTaskController.tachesList
        .where(
            (task) => task.titre!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      affectedTaskController.displayList.value = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
        onWillPop: () async {
          // before the user leaves the page.
          _RemoveStorageData();
          return true; // Return true to allow the user to leave the page.
        },
        child: Scaffold(
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
                        hintText: "Rechercher Tache",
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
                  TotalTache(
                      totalTache: affectedTaskController.displayList.length),
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
                  NouveauTache(taches: affectedTaskController.displayList),
                  RectifierTache(taches: affectedTaskController.displayList),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(const CreateTask(),
                  arguments: widget.idChantier,
                  binding: AffectedTaskBindings());
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: isPortrait
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.centerFloat,
        ));
  }
}
