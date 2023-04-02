import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/list_tache/widget/nouveau_tache.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/list_tache/widget/rectifier_tache.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/list_tache/widget/total_tache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/tache.dart';
import '../../../../services/api_Client.dart';
import '../filter-tache/tache_filter_page.dart';



class ListTache extends StatefulWidget {
  final chantier;
  const ListTache({super.key, required this.chantier});
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
    setState(() {

    });
  }
  //Methode de filtre
  void updateData(List newData) {
    setState(() {
      _dataFromFiltre=newData;
      //Trier Liste

      if (_dataFromFiltre![0]==true)
      {
        displayList.sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));
      }
      else if (_dataFromFiltre![0]==false)
      {
        displayList.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
      }
      else if (_dataFromFiltre![0]==null)
      {       displayList=[];
      displayList=taches;
      }
      //Filtre avec type (Rectification/Nouveau)

      if (_dataFromFiltre![1]==null&& _dataFromFiltre![2]==null)
      {
        displayList=[];
        displayList=taches;
      }
      else if (_dataFromFiltre![1]!=null&& _dataFromFiltre![2]!=null)
      {
        displayList=[];
        displayList=taches;
      }
      else if (_dataFromFiltre![1]==false)
      {
        displayList = displayList.where((item) => item.type=="rectification").toList();

      }
      else if (_dataFromFiltre![2]==true)
      {
        displayList = displayList.where((item) => item.type=="nouveau").toList();

      }
    });
  }


  Future<void> getTaches() async {

    taches=await ApiClient.getTaches('/chefChantiers/1/chantier/${widget.chantier.id}/taches');
    taches = taches.where((item) => item.etat==true).toList();

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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // before the user leaves the page.
          _RemoveStorageData();
          return true; // Return true to allow the user to leave the page.
        },
        child:Scaffold(
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
                        hintText:"Rechercher une tâche",
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
          ),
        )
    );
  }
}




