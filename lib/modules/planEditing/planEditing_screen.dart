import 'package:flutter/material.dart';
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

  void _showMessage(int index) {
    // Afficher un message en fonction de l'index de la zone cliquée
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Element : ${pec.listElems[index].reference}'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Hauteur:${pec.listElems[index].hauteur}'),
              Text('Largeur:${pec.listElems[index].largeur}'),
              Text('Surface:${pec.listElems[index].surface}'),
              Text('Gamme:${pec.listElems[index].gamme}'),
              Text(
                'Phase:${pec.listElems[index].phase}',
                style: TextStyle(
                    color: pec.listElems[index].phase == 'estimation'
                        ? Colors.lime
                        : pec.listElems[index].phase == 'elaboration'
                            ? Colors.pink
                            : pec.listElems[index].phase == 'fabrication'
                                ? Colors.green
                                : Colors.black),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              pec.supprimerZone(pec.lesZones[index]);
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
                  title: Text('Modifier ${pec.listElems[index].reference}'),
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
                            try {
                              element.Element data = element.Element(
                                  reference: pec.listElems[index].reference,
                                  id: pec.listElems[index].id,
                                  phase: _selectedPhase,
                                  surface: _surfaceController.text,
                                  gamme: pec.listElems[index].gamme,
                                  hauteur: _hauteurController.text,
                                  largeur: _largeurController.text,
                                  etageId: pec.listElems[index].etageId);
                              await pec.updateElement(
                                  data, pec.listElems[index].id!);
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
                      // Block du code qui est responsable de l'image editing
                      GestureDetector(
                          //Methode pour capturer un clique et affiche les details
                          onTapUp: (details) {
                            // Parcourir toutes les zones et vérifier si le clic est à l'intérieur de l'une d'entre elles
                            for (int i = 0; i < pec.zones.length; i++) {
                              if (pec.zones[i]
                                  .contains(details.localPosition)) {
                                _showMessage(i);
                                break;
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              OrientationBuilder(
                                builder: (context, orientation) {
                                  return Image.network(
                                    pec.plan.value,
                                    fit: orientation == Orientation.portrait
                                        ? BoxFit.cover
                                        : BoxFit.contain,
                                  );
                                },
                              ),

                              //Code des nouvelles boxes
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
                                      final rect =
                                          Rect.fromPoints(start!, end!);
                                      if (!pec.rects.any(
                                              (box) => box.overlaps(rect)) &&
                                          !pec.zones.any(
                                              (box) => box.overlaps(rect))) {
                                        pec.rects.add(rect);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Zone déjà utilisé !! ')));
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
                                    Image.network(
                                      pec.plan.value,
                                      fit: BoxFit.cover,
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
                                                            startLocal,
                                                            endLocal);
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
                                                        child: pec.notZonedElems
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
                                                                    items: pec
                                                                        .notZonedElems
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
                                                                          x: pec
                                                                              .rects[
                                                                                  index]
                                                                              .left
                                                                              .toInt(),
                                                                          y: pec
                                                                              .rects[
                                                                                  index]
                                                                              .top
                                                                              .toInt(),
                                                                          width: pec
                                                                              .rects[
                                                                                  index]
                                                                              .width
                                                                              .toInt(),
                                                                          height: pec
                                                                              .rects[index]
                                                                              .height
                                                                              .toInt());
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
                              ...pec.zones.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final Rect zone = entry.value;
                                return Positioned(
                                  left: zone.left,
                                  top: zone.top,
                                  width: zone.width,
                                  height: zone.height,
                                  child: Container(
                                    decoration: pec.listElems[index].phase ==
                                            "elaboration"
                                        ? BoxDecoration(
                                            color: Colors.pink.withOpacity(0.2),
                                            border: Border.all(
                                                color: Colors.pink, width: 2),
                                          )
                                        : pec.listElems[index].phase ==
                                                "estimation"
                                            ? BoxDecoration(
                                                color: Colors.yellow
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                    color: Colors.yellow,
                                                    width: 2),
                                              )
                                            : pec.listElems[index].phase ==
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
                                    child: Text(
                                        '${pec.listElems[index].reference}'),
                                  ),
                                );
                              }).toList(),
                            ],
                          )),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
