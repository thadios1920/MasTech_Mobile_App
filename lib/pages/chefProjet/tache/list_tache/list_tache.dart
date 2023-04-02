import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/list_tache/widget/nouveau_tache.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/list_tache/widget/rectifier_tache.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/list_tache/widget/total_tache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/tache.dart';
import '../../../../services/api_Client.dart';
import '../../create_task.dart';

import '../filter-tache/tache_filter_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListTache extends StatefulWidget {
  final idChantier;
  const ListTache({super.key, required this.idChantier});
  @override
  State<ListTache> createState() => _ListTacheState();
}

class _ListTacheState extends State<ListTache> {
  late SharedPreferences _prefs;
  List? _dataFromFiltre;
  final _searchController = TextEditingController();
  List<Tache> taches = [];
  late List<Tache>displayList =[];


  @override
  void initState() {
    getTaches();
    super.initState();
  }

  Future<void> _RemoveStorageData() async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove('sortedStorage');
    await _prefs.remove('etatRectificationStorage');
    await _prefs.remove('etatNouveauStorage');
    setState(() {

    });
  }
  //Methode de filtre
  void updateData(List newData) {
    setState(() {
      //Trier Liste

      _dataFromFiltre=newData;
      if (_dataFromFiltre![0]==true)
      {
        displayList.sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));
      }
      else if (_dataFromFiltre![0]==false)
      {
        displayList.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
      }
      else if (_dataFromFiltre![0]==null)
      {     displayList=[];
      displayList=taches;
      }

      //Filtre avec type (Rectification/Nouveau)

      if ((_dataFromFiltre![1]!=null|| _dataFromFiltre![2]!=null)&& (_dataFromFiltre![1]!=null&& _dataFromFiltre![2]!=null)) {
        if (_dataFromFiltre![1] == false) {
          displayList =
              displayList.where((item) => item.type == "rectification")
                  .toList();
        }
        else if (_dataFromFiltre![2] == true) {
          displayList =
              displayList.where((item) => item.type == "nouveau").toList();
        }
      }
      else if (_dataFromFiltre![1]==null&& _dataFromFiltre![2]==null)
      {

        displayList=[];
        displayList=taches;
      }
      else if (_dataFromFiltre![1]!=null&& _dataFromFiltre![2]!=null )
      {
        displayList=[];
        displayList=taches;
      }


      //Filtre avec Type(Encours/Terminer)

      if (_dataFromFiltre![3]!=null|| _dataFromFiltre![4]!=null ) {
        if (_dataFromFiltre![3] == false) {
          displayList =
              displayList.where((item) => item.etat == false).toList();
        }
        else if (_dataFromFiltre![4] == true) {
          displayList = displayList.where((item) => item.etat == true).toList();
        }
      }
      else if (_dataFromFiltre![3]==null&& _dataFromFiltre![4]==null)
      {
        displayList=[];
        displayList=taches;
      }
      else if (_dataFromFiltre![3]!=null&& _dataFromFiltre![4]!=null)
      {
        displayList=[];
        displayList=taches;
      }
    });
  }


  Future<void> getTaches() async {

    taches=await ApiClient.getTaches('/chantiers/${widget.idChantier}/taches');
    if (taches.isNotEmpty) {
      setState(() {
        displayList=taches;
      });
    }
  }

  void _search(String value) {
    List<Tache> results = [];
    results = taches
        .where((element) =>
        element.titre!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      displayList=results;
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
        child:Scaffold(
          body: Container(


            child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(

                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        _search(value);
                      },
                      controller: _searchController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,

                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText:  _dataFromFiltre.toString(),
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
                              showModalBottomSheet(
                                context: context,
                                enableDrag: false,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(

                                  height: 400,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: FilterPage(callback: updateData),

                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(

                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.filter_list,
                                      color: Colors.white),
                                  const Text("Filtre",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TotalTache(totalTache: displayList.length),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Color.fromRGBO(97, 99, 119, 1),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  NouveauTache(taches: displayList),
                  RectifierTache(taches: displayList),

                ],
              ),
            ),
          ), floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateTask(idChantier: widget.idChantier),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
          floatingActionButtonLocation: isPortrait
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.centerFloat,
        )
    );

  }

}




