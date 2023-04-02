
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  final Function callback;

  FilterPage({required this.callback});


  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late SharedPreferences _prefs;

  bool? sorted;
  bool? etatEncours;
  bool? etatTerminer;
  bool? etatRectification;
  bool? etatNouveau;
  List filter=[];
  late String sortedStorage;
  late String etatEncoursStorage;
  late String etatTerminerStorage;
  late String etatRectificationStorage;
  late String etatNouveauStorage;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    var sortedStorage = _prefs.getString('sortedStorage') ;
    var etatEncoursStorage = _prefs.getString('etatEncoursStorage') ;
    var etatTerminerStorage = _prefs.getString('etatTerminerStorage') ;
    var etatRectificationStorage = _prefs.getString('etatRectificationStorage') ;
    var etatNouveauStorage = _prefs.getString('etatNouveauStorage') ;
    setState(() {
      sorted = sortedStorage == 'null' ? null : sortedStorage == 'true';
      etatEncours = etatEncoursStorage == 'null' ? null : etatEncoursStorage == 'true';
      etatTerminer = etatTerminerStorage == 'null' ? null : etatTerminerStorage == 'true';
      etatRectification = etatRectificationStorage == 'null' ? null : etatRectificationStorage == 'true';
      etatNouveau = etatNouveauStorage == 'null' ? null : etatNouveauStorage == 'true';


    });
  }

  Future<void> _saveData(String sorted,String etatEncours,String etatTerminer,String etatRectification,String etatNouveau ) async {
    await _prefs.setString('sortedStorage',sorted);
    await _prefs.setString('etatEncoursStorage', etatEncours );
    await _prefs.setString('etatTerminerStorage', etatTerminer);
    await _prefs.setString('etatRectificationStorage', etatRectification);
    await _prefs.setString('etatNouveauStorage', etatNouveau);


  }
   @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
              filter=[];
                sorted=null;
                etatEncours=null;
                etatTerminer=null;
                etatRectification=null;
                etatNouveau=null;

                filter.add(etatTerminer);
              _saveData(sortedStorage="null",etatEncoursStorage="null",etatTerminerStorage="null",etatRectificationStorage='null',etatNouveauStorage='null');
              filter.add(sorted);
              filter.add(etatEncours);
              filter.add(etatRectification);
              filter.add(etatNouveau);

              widget.callback(filter);
              });

            },
            child: Text("Reset"),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
        ],
        title: Text("Filter"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Divider(),
            Row(
              children: [
                Text(
                  "Trier Par",
                  style: TextStyle(fontSize: 16),
                ),

              ],
            ),
            SizedBox(
              child: Wrap(
                direction: Axis.horizontal,
                runSpacing: 6,
                spacing: 6,
                children: [
                  InputChip(
                    label: Text('Plus Ancien'),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.black54,
                    selectedColor: Colors.blue,
                    selected: sorted == false,
                    onSelected: (bool selected) {
                      setState(() {
                        filter=[];
                        sorted = selected ? false : null;
                        _saveData(sortedStorage=sortedStorage=selected ? 'false' : 'null',etatEncoursStorage=etatEncours.toString(),etatTerminerStorage=etatTerminer.toString(),etatRectificationStorage=etatRectification.toString(),etatNouveauStorage=etatNouveau.toString());
                        filter.add(sorted);
                        filter.add(etatEncours);
                        filter.add(etatTerminer);
                        filter.add(etatRectification);
                        filter.add(etatNouveau);
                        widget.callback(filter);


                      });
                    },
                  ),
                  InputChip(
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.black54,
                    selectedColor: Colors.blue,
                    label: Text('Plus Récent'),

                    selected: sorted == true,
                    onSelected: (bool selected) {
                      setState(() {
                        filter=[];
                        sorted = selected ? true : null;
                        _saveData(sortedStorage=selected ? 'true' : 'null',etatEncoursStorage=etatEncours.toString(),etatTerminerStorage=etatTerminer.toString(),etatRectificationStorage=etatRectification.toString(),etatNouveauStorage=etatNouveau.toString());
                        filter.add(sorted);
                        filter.add(etatEncours);
                        filter.add(etatTerminer);
                        filter.add(etatRectification);
                        filter.add(etatNouveau);
                        widget.callback(filter);

                      });
                    },
                  )
],
              ),
            ),

            ExpansionTile(

              title: Text("Type"),
              initiallyExpanded: true,

              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 6,
                    spacing: 6,
                    children: [
                      InputChip(
                      label: Text('Réctification'),
                        labelStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.blue,
                      selected: etatRectification == false,
                      onSelected: (bool selected) {
                        setState(() {
                          filter=[];
                          etatRectification = selected ? false : null;
                          _saveData(sortedStorage=sorted.toString(),etatEncoursStorage=etatEncours.toString(),etatTerminerStorage=etatTerminer.toString(),etatRectificationStorage=selected ? 'false' : 'null',etatNouveauStorage=etatNouveau.toString());
                          filter.add(sorted);
                          filter.add(etatEncours);
                          filter.add(etatTerminer);
                          filter.add(etatRectification);
                          filter.add(etatNouveau);
                          widget.callback(filter);
                        });
                      },
                    ),
                      InputChip(
                        labelStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.blue,
                        label: Text('Nouveau'),

                        selected: etatNouveau == true,
                        onSelected: (bool selected) {
                          setState(() {
                            filter=[];
                            etatNouveau = selected ? true : null;
                            _saveData(sortedStorage=sorted.toString(),etatEncoursStorage=etatEncours.toString(),etatTerminerStorage=etatTerminer.toString(),etatRectificationStorage=etatRectification.toString(),etatNouveauStorage= selected ? 'true' : 'null');
                            filter.add(sorted);
                            filter.add(etatEncours);
                            filter.add(etatTerminer);
                            filter.add(etatRectification);
                            filter.add(etatNouveau);
                            widget.callback(filter);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(

              title: Text("Etat"),
              initiallyExpanded: true,

              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 6,
                    spacing: 6,
                    children: [
                      InputChip(
                        label: Text('En cours...'),
                        labelStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.blue,
                        selected: etatEncours == false,
                        onSelected: (bool selected) {
                          setState(() {
                            filter=[];
                            etatEncours = selected ? false : null;
                            _saveData(sortedStorage=sorted.toString(),etatEncoursStorage=selected ? 'false' : 'null',etatTerminerStorage=etatTerminer.toString(),etatRectificationStorage=etatRectification.toString(),etatNouveauStorage=etatNouveau.toString());
                            filter.add(sorted);
                            filter.add(etatEncours);
                            filter.add(etatTerminer);
                            filter.add(etatRectification);
                            filter.add(etatNouveau);
                            widget.callback(filter);
                          });
                        },
                      ),
                      InputChip(
                        labelStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.blue,
                        label: Text('Terminer'),

                        selected: etatTerminer == true,
                        onSelected: (bool selected) {
                          setState(() {
                            filter=[];
                            etatTerminer = selected ? true : null;
                            _saveData(sortedStorage=sorted.toString(),etatEncoursStorage=etatEncours.toString(),etatTerminerStorage = selected ? 'true' : 'null',etatRectificationStorage=etatRectification.toString(),etatNouveauStorage=etatNouveau.toString());
                            filter.add(sorted);
                            filter.add(etatEncours);
                            filter.add(etatTerminer);
                            filter.add(etatRectification);
                            filter.add(etatNouveau);
                            widget.callback(filter);
                          });
                        },
                      )
                    ],
                  ),
                ),


              ],
            ),

          ],
        ),
      ),
    );
  }

}
