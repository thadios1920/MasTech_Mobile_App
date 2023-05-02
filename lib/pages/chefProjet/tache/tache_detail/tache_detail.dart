import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/tache_detail/widgets/tache_description.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/tache_detail/widgets/tache_image.dart';
import 'package:pfe_mobile_app/pages/chefProjet/tache/tache_detail/widgets/Tacheheader.dart';
import '../../../../models/tache.dart';
import '../../../../services/api_Client.dart';

class TacheDetail extends StatefulWidget {
  final Tache tache;
  TacheDetail({required this.tache});

  @override
  State<TacheDetail> createState() => _TacheDetailState();
}

class _TacheDetailState extends State<TacheDetail> {
  Future<void> _rectifierTask(File image, int idTask, String desc) async {
    await ApiClient.rectifierTache(image, '/taches/$idTask/rectifier', desc);
  }

  Future<void> _validerTask(int idTask) async {
    await ApiClient.modifierTache('/taches/$idTask/valider');
    setState(() {});
  }

  Future<void> _deleteTask(int idTask) async {
    await ApiClient.supprimmerTache('/taches/$idTask');
  }

  final _descriptionController = TextEditingController();
  String _taskNotes = "";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textarea = TextEditingController();

    Tache tache = widget.tache;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la tâche'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Tacheheader(tache: tache),
            const SizedBox(
              height: 50.0,
            ),
            TacheImage(imageURL: tache.imageURL ?? ""),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                  readOnly: true,
                  controller: textarea,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    hintStyle: const TextStyle(color: Colors.black),
                    hintText: "Description:\n${tache.description}",
                  )),
            ),
            TacheDescription(tache: tache),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Tache tache = Tache(
                            titre: widget.tache.titre,
                            description: widget.tache.description,
                            type: widget.tache.type,
                            statut: true,
                            etat: widget.tache.etat);
                        try {
                          await _validerTask(widget.tache.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tâche Validée')));
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Opération Echouée')));
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Valider",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: const Text('Rectifier la tâche'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          setState(() {
                                            _imageFile = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: _imageFile == null
                                            ? const Center(
                                                child: Icon(Icons.camera_alt,
                                                    size: 50),
                                              )
                                            : Image.file(_imageFile!),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Ajouter une description',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer une description';
                                        }
                                        return null;
                                      },
                                      maxLines: 5,
                                      onChanged: (String value) {
                                        setState(() {
                                          _taskNotes = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Annuler'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('Soumettre'),
                                    onPressed: () async {
                                      if (_imageFile != null) {
                                        try {
                                          _rectifierTask(_imageFile!, tache.id!,
                                              _descriptionController.text);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Photo envoyée avec succès'),
                                          ));
                                        } catch (e) {
                                          print(e);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Veuillez prendre une photo'),
                                        ));
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                "Rectifier",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _deleteTask(widget.tache.id!);
                        setState(() {});

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tâche supprimée')));
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Supprimer",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
