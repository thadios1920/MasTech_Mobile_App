import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imgs;
import 'package:http/http.dart' as http;
import 'package:pfe_mobile_app/services/api_Client.dart';
import '../../models/element.dart' as element;

import 'models/etage.dart';
import 'models/zone.dart';

class ImageZoningPage extends StatefulWidget {
  final String plan;
  final Etage etage;
  const ImageZoningPage({required this.plan, required this.etage, super.key});

  @override
  _ImageZoningPageState createState() => _ImageZoningPageState();
}

class _ImageZoningPageState extends State<ImageZoningPage> {
  File? _image;
  final List<Rect> _zones = [];
  List<Zone> lesZones = [];
  List<element.Element> listElems = [];
  List<element.Element> notZonedElems = [];
  List zonesList = [];
  Offset? _start;
  Offset? _end;
  int _selectedZoneIndex = -1;
  final List<Rect> _rects = [];
  Image imageDims = Image.network("");

  @override
  void initState() {
    _getImage();

    super.initState();
  }

  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController();
  final _largeurController = TextEditingController();

  // Methode pour ajouter une zone
  _createZone(Zone zone, idElement) async {
    await ApiClient.ajouterZone('/zones/element/$idElement', zone);
    setState(() {});
  }

  Future<void> _updateElement(element.Element elem, int idElem) async {
    await ApiClient.modifierElement('/elements/$idElem', elem);

    setState(() {
      // rechercher l'élément mis à jour dans la liste et le mettre à jour
      int index = listElems.indexWhere((elem) => elem.id == idElem);
      var largeur = elem.largeur ?? listElems[index].largeur;
      var hauteur = elem.hauteur ?? listElems[index].hauteur;
      // var surface = int.parse(largeur!) * int.parse(hauteur!);
      late element.Element newElem = element.Element(
          reference: listElems[index].reference,
          gamme: listElems[index].gamme ?? elem.gamme,
          largeur: largeur,
          hauteur: hauteur,
          // surface: surface.toString(),
          phase: elem.phase ?? listElems[index].phase);
      listElems[index] = newElem;
    });
  }

  Future<void> _affecterElement(int idElem) async {
    await ApiClient.affecterElement('/elements/$idElem/affecte');

    setState(() {});
  }

  Future<void> getElements() async {
    listElems =
        await ApiClient.getElements("/etages/${widget.etage.id}/elements");

    if (listElems.isNotEmpty) {
      await getListZones();
      for (var elem in listElems) {
        if (elem.affecte == false) {
          notZonedElems.add(elem);
        }
      }
      setState(() {});
    }
  }

  List<String> phases = ["estimation", "elaboration", "fabrication"];

  var _selectedPhase;
  var _selectedelem;

  Future<void> getListZones() async {
    try {
      for (var i = 0; i < listElems.length; i++) {
        var zone = await ApiClient.getZone("/elements/${listElems[i].id}/zone");

        setState(() {
          zonesList.add(zone);
        });
        Zone newZone = Zone(
            x: int.parse(zonesList[i]['x']),
            y: int.parse(zonesList[i]['y']),
            width: int.parse(zonesList[i]['width']),
            height: int.parse(zonesList[i]['height']));
        lesZones.add(newZone);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _showMessage(int index) {
    // Afficher un message en fonction de l'index de la zone cliquée
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Element : ${listElems[index].reference}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Hauteur:${listElems[index].hauteur}'),
            Text('Largeur:${listElems[index].largeur}'),
            Text('Surface:${listElems[index].surface}'),
            Text('Gamme:${listElems[index].gamme}'),
            Text(
              'Phase:${listElems[index].phase}',
              style: TextStyle(
                  color: listElems[index].phase == 'estimation'
                      ? Colors.lime
                      : listElems[index].phase == 'elaboration'
                          ? Colors.pink
                          : listElems[index].phase == 'fabrication'
                              ? Colors.green
                              : Colors.black),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Modifier ${listElems[index].reference}'),
                  content: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _largeurController,
                          decoration: const InputDecoration(
                            labelText: 'Largeur',
                          ),
                        ),
                        TextFormField(
                          controller: _hauteurController,
                          decoration: const InputDecoration(
                            labelText: 'Hauteur',
                          ),
                        ),
                        DropdownButton<String>(
                          hint: const Text("Phase"),
                          value: _selectedPhase,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPhase = newValue!;
                            });
                          },
                          items: phases.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            element.Element data = element.Element(
                                phase: _selectedPhase,
                                surface: _surfaceController.text,
                                hauteur: _hauteurController.text,
                                largeur: _largeurController.text,
                                etageId: listElems[index].etageId);
                            await _updateElement(data, listElems[index].id!);
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Soumettre'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Text('Modifier'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    await getElements();

    try {
      final response = await http.get(Uri.parse(widget.plan));
      if (response.statusCode == 200) {
        // Verify that the response is an image file
        if (response.headers['content-type']?.startsWith('image') ?? false) {
          try {
            setState(() {
              _image = File.fromRawPath(response.bodyBytes);
              // imageDims = Image.file(_image!);
              // final img1 = imgs.decodeImage(_image!.readAsBytesSync());
              // print("${img1!.height}");
              _zones.addAll(lesZones.map((zone) => Rect.fromLTWH(
                  zone.x!.toDouble(),
                  zone.y!.toDouble(),
                  zone.width!.toDouble(),
                  zone.height!.toDouble())));
            });

            // final imageBytes = await _image!.readAsBytes();
            // final decodedImage = imgs.decodeImage(imageBytes);
            // print("${decodedImage!.height}");
          } catch (e) {
            print('Error creating File object: $e'); // Debugging statement
          }
        } else {
          print('Response is not an image file');
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error retrieving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etage : ${widget.etage.numero}'),
      ),
      body: SingleChildScrollView(
        child: _image == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_image != null) ...[
                    // Block du code qui est responsable de l'image editing
                    GestureDetector(
                        //Methode pour capturer un clique et affiche les details
                        onTapUp: (details) {
                          // Parcourir toutes les zones et vérifier si le clic est à l'intérieur de l'une d'entre elles
                          for (int i = 0; i < _zones.length; i++) {
                            if (_zones[i].contains(details.localPosition)) {
                              _showMessage(i);
                              break;
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            Image.network(widget.plan),
                            //Code des nouvelles boxes
                            GestureDetector(
                              onPanStart: (details) {
                                _start = details.localPosition;
                                setState(() {
                                  _selectedZoneIndex = -1;
                                });
                              },
                              onPanEnd: (details) {
                                if (_start != null && _end != null) {
                                  setState(() {
                                    final rect =
                                        Rect.fromPoints(_start!, _end!);
                                    if (!_rects
                                            .any((box) => box.overlaps(rect)) &&
                                        !_zones
                                            .any((box) => box.overlaps(rect))) {
                                      _rects.add(rect);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Zone déjà utilisé !! ')));
                                    }
                                    _start = null;
                                    _end = null;
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                _end = details.localPosition;
                                setState(() {});
                              },
                              child: Stack(
                                children: <Widget>[
                                  Image.network(
                                    widget.plan,
                                    fit: BoxFit.cover,
                                  ),
                                  ..._rects.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final rect = entry.value;
                                    return Positioned.fromRect(
                                      rect: rect,
                                      child: Stack(
                                        children: [
                                          if (_selectedZoneIndex == index)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.8),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          GestureDetector(
                                            onPanStart: (details) {
                                              _start = details.localPosition;
                                              setState(() {
                                                _selectedZoneIndex = index;
                                              });
                                            },
                                            onPanEnd: (details) {
                                              _start = null;
                                              _end = null;
                                            },
                                            onPanUpdate: (details) {
                                              _end = details.localPosition;
                                              if (_start != null &&
                                                  _end != null) {
                                                final renderBox =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final startLocal = renderBox
                                                    .globalToLocal(_start!);
                                                final endLocal = renderBox
                                                    .globalToLocal(_end!);
                                                setState(() {
                                                  _rects[index] =
                                                      Rect.fromPoints(
                                                          startLocal, endLocal);
                                                });
                                              }
                                            },
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Definire l\'élement'),
                                                    content: Form(
                                                      child: notZonedElems
                                                              .isEmpty
                                                          ? const Text(
                                                              "Touts les élements sont affectées")
                                                          : Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                DropdownButton<
                                                                    String>(
                                                                  hint: const Text(
                                                                      "Choisissez un element"),
                                                                  value:
                                                                      _selectedelem,
                                                                  onChanged:
                                                                      (newValue) {
                                                                    setState(
                                                                        () {
                                                                      _selectedelem =
                                                                          newValue!;
                                                                    });
                                                                  },
                                                                  items: notZonedElems
                                                                      .where((elem) =>
                                                                          elem.reference !=
                                                                          null)
                                                                      .map<DropdownMenuItem<String>>(
                                                                          (elem) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value: elem
                                                                          .id
                                                                          .toString(),
                                                                      child: Text(
                                                                          elem.reference!),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Zone z = Zone(
                                                                        x: _rects[index]
                                                                            .left
                                                                            .toInt(),
                                                                        y: _rects[index]
                                                                            .top
                                                                            .toInt(),
                                                                        width: _rects[index]
                                                                            .width
                                                                            .toInt(),
                                                                        height: _rects[index]
                                                                            .height
                                                                            .toInt());
                                                                    try {
                                                                      await _createZone(
                                                                          z,
                                                                          _selectedelem);
                                                                      await _affecterElement(
                                                                          int.parse(
                                                                              _selectedelem));
                                                                      Navigator.pop(
                                                                          context);
                                                                    } catch (e) {
                                                                      print(e);
                                                                    }
                                                                  }, //capturer dimentions zone et affecter la a l'element
                                                                  child: const Text(
                                                                      'Soumettre'),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.8),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            //codes des boxes venenants de la API
                            ..._zones.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final Rect zone = entry.value;
                              return Positioned(
                                left: zone.left,
                                top: zone.top,
                                width: zone.width,
                                height: zone.height,
                                child: Container(
                                  decoration: listElems[index].phase ==
                                          "elaboration"
                                      ? BoxDecoration(
                                          color: Colors.pink.withOpacity(0.2),
                                          border: Border.all(
                                              color: Colors.pink, width: 2),
                                        )
                                      : listElems[index].phase == "estimation"
                                          ? BoxDecoration(
                                              color: Colors.yellow
                                                  .withOpacity(0.2),
                                              border: Border.all(
                                                  color: Colors.yellow,
                                                  width: 2),
                                            )
                                          : listElems[index].phase ==
                                                  "fabrication"
                                              ? BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      width: 2),
                                                )
                                              : BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                  child: Text('${listElems[index].reference}'),
                                ),
                              );
                            }).toList(),
                          ],
                        )),
                  ],
                ],
              ),
      ),
    );
  }
}
