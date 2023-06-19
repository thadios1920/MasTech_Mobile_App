import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/planEditing/planEditing_controller.dart';
import '../../models/element.dart' as element;
import '../../models/zone.dart';

class ImageZoningPage extends StatefulWidget {
  const ImageZoningPage({super.key});

  @override
  _ImageZoningPageState createState() => _ImageZoningPageState();
}

class _ImageZoningPageState extends State<ImageZoningPage> {
  final PlanEditingController pec = Get.put(PlanEditingController());
  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController();
  final _largeurController = TextEditingController();

  List<String> phases = ["estimation", "elaboration", "fabrication"];

  var _selectedPhase;

  var _selectedelem;
  Offset? start;
  Offset? end;

  void _showMessage(Rect rect) {
    pec.elementZoneRectMap.forEach((elem, zoneRectMap) {
      zoneRectMap.forEach((zone, zoneRect) {
        if (zoneRect == rect) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Element : ${elem.reference}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Hauteur: ${elem.hauteur} m'),
                  Text('Largeur: ${elem.largeur} m'),
                  Text('Surface: ${elem.surface} m²'),
                  Text('Gamme: ${elem.gamme}'),
                  Text(
                    'Phase: ${elem.phase}',
                    style: TextStyle(
                      color: elem.phase == 'estimation'
                          ? Colors.lime
                          : elem.phase == 'elaboration'
                              ? Colors.pink
                              : elem.phase == 'fabrication'
                                  ? Colors.green
                                  : Colors.black,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await pec.supprimerZone(zone, elem);
                    Navigator.pop(context);
                  },
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
                        title: Text('Modifier ${elem.reference}'),
                        content: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                // controller: _largeurController,
                                initialValue: elem.largeur,
                                decoration: const InputDecoration(
                                  labelText: 'Largeur',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]')),
                                ],
                                onChanged: (value) {
                                  pec.isButtonEnabled.value =
                                      _largeurController.text.isNotEmpty ||
                                          _hauteurController.text.isNotEmpty ||
                                          _selectedPhase != null;
                                },
                              ),
                              TextFormField(
                                // controller: _hauteurController,
                                initialValue: elem.hauteur,
                                decoration: const InputDecoration(
                                  labelText: 'Hauteur',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]')),
                                ],
                                onChanged: (value) {
                                  pec.isButtonEnabled.value =
                                      _largeurController.text.isNotEmpty ||
                                          _hauteurController.text.isNotEmpty ||
                                          _selectedPhase != null;
                                },
                              ),
                              DropdownButton<String>(
                                hint: const Text("Phase"),
                                value: _selectedPhase,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPhase = newValue!;
                                    pec.isButtonEnabled.value =
                                        _largeurController.text.isNotEmpty ||
                                            _hauteurController
                                                .text.isNotEmpty ||
                                            _selectedPhase != null;
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
                                  try {
                                    element.Element data = element.Element(
                                      reference: elem.reference,
                                      id: elem.id,
                                      phase: _selectedPhase,
                                      surface: _surfaceController.text,
                                      gamme: elem.gamme,
                                      hauteur: _hauteurController.text,
                                      largeur: _largeurController.text,
                                      etageId: elem.etageId,
                                    );
                                    await pec.updateElement(data, elem.id!);
                                  } catch (e) {
                                    throw (e);
                                  }

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etage : ${pec.etage.value.numero}'),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: pec.image == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (pec.image != null) ...[
                      GestureDetector(
                        onTapUp: (details) {
                          pec.elementZoneRectMap
                              .forEach((element, zoneRectMap) {
                            zoneRectMap.forEach((zone, rect) {
                              if (rect.contains(details.localPosition)) {
                                _showMessage(rect);
                              }
                            });
                          });
                        },
                        child: Stack(
                          children: [
                            // RotatedBox(
                            //   quarterTurns:
                            //       1, // Effectue une rotation de 90 degrés (horizontalement)
                            //   child: Image.network(
                            //     pec.plan.value,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            GestureDetector(
                              onPanStart: (details) {
                                start = details.localPosition;
                                setState(() {
                                  pec.selectedZoneIndex = -1;
                                });
                              },
                              onPanEnd: (details) {
                                if (start != null && end != null) {
                                  setState(() {
                                    final rect = Rect.fromPoints(start!, end!);
                                    if (!pec.rects
                                            .any((box) => box.overlaps(rect)) &&
                                        !pec.zones
                                            .any((box) => box.overlaps(rect))) {
                                      pec.rects.add(rect);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Zone déjà utilisée !'),
                                        ),
                                      );
                                    }
                                    start = null;
                                    end = null;
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                end = details.localPosition;
                                setState(() {});
                              },
                              child: Stack(
                                children: <Widget>[
                                  RotatedBox(
                                    quarterTurns:
                                        1, // Effectue une rotation de 90 degrés (horizontalement)
                                    child: Image.network(
                                      pec.plan.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ...pec.rects.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final rect = entry.value;
                                    return Positioned.fromRect(
                                      rect: rect,
                                      child: Stack(
                                        children: [
                                          if (pec.selectedZoneIndex == index)
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
                                              start = details.localPosition;
                                              setState(() {
                                                pec.selectedZoneIndex = index;
                                              });
                                            },
                                            onPanEnd: (details) {
                                              start = null;
                                              end = null;
                                            },
                                            onPanUpdate: (details) {
                                              end = details.localPosition;
                                              if (start != null &&
                                                  end != null) {
                                                final renderBox =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final startLocal = renderBox
                                                    .globalToLocal(start!);
                                                final endLocal = renderBox
                                                    .globalToLocal(end!);
                                                setState(() {
                                                  pec.rects[index] =
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
                                                  return Obx(
                                                    () => AlertDialog(
                                                      title: const Text(
                                                          'Définir l\'élément'),
                                                      content: Form(
                                                        child: pec.notZonedElems
                                                                .isEmpty
                                                            ? const Text(
                                                                "Aucun élément disponible")
                                                            : Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  DropdownButton<
                                                                      String>(
                                                                    hint: const Text(
                                                                        'Choisissez un élément'),
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
                                                                    items: pec
                                                                        .notZonedElems
                                                                        .where((elem) =>
                                                                            elem.affecte ==
                                                                            false) // Filtrer les éléments non affectés
                                                                        .where((elem) =>
                                                                            elem.reference !=
                                                                            null) // Exclure les éléments sans référence
                                                                        .map<
                                                                            DropdownMenuItem<String>>(
                                                                          (elem) =>
                                                                              DropdownMenuItem<String>(
                                                                            value:
                                                                                elem.id.toString(),
                                                                            child:
                                                                                Text(elem.reference!),
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Zone z =
                                                                          Zone(
                                                                        x: pec
                                                                            .rects[index]
                                                                            .left
                                                                            .toInt(),
                                                                        y: pec
                                                                            .rects[index]
                                                                            .top
                                                                            .toInt(),
                                                                        width: pec
                                                                            .rects[index]
                                                                            .width
                                                                            .toInt(),
                                                                        height: pec
                                                                            .rects[index]
                                                                            .height
                                                                            .toInt(),
                                                                      );
                                                                      try {
                                                                        await pec.createZone(
                                                                            z,
                                                                            _selectedelem);
                                                                        await pec
                                                                            .affecterElement(int.parse(_selectedelem));
                                                                        Navigator.pop(
                                                                            context);
                                                                      } catch (e) {
                                                                        print(
                                                                            e);
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Soumettre'),
                                                                  ),
                                                                ],
                                                              ),
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
                            ...pec.zones.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final Rect zone = entry.value;
                              return Positioned(
                                left: zone.left,
                                top: zone.top,
                                width: zone.width,
                                height: zone.height,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: pec.listElems[index].phase ==
                                            'elaboration'
                                        ? Colors.pink.withOpacity(0.2)
                                        : pec.listElems[index].phase ==
                                                'estimation'
                                            ? Colors.yellow.withOpacity(0.2)
                                            : pec.listElems[index].phase ==
                                                    'fabrication'
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.blue.withOpacity(0.2),
                                    border: Border.all(
                                      color: pec.listElems[index].phase ==
                                              'elaboration'
                                          ? Colors.pink
                                          : pec.listElems[index].phase ==
                                                  'estimation'
                                              ? Colors.yellow
                                              : pec.listElems[index].phase ==
                                                      'fabrication'
                                                  ? Colors.green
                                                  : Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(pec.getElementFromRect(zone)),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
