import 'package:flutter/material.dart';
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
  Future<void> _updateTask(Tache tache, int idTask) async {
    await ApiClient.modifierTache('/taches/$idTask', tache);
    setState(() {});
  }

  Future<void> _deleteTask(int idTask) async {
    await ApiClient.supprimmerTache('/taches/$idTask');
    setState(() {});
  }

  final _descriptionController = TextEditingController();
  String _taskNotes = "";

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
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(Icons.library_add_check),
            color: Colors.green,
          )
        ],
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
            TacheImage(),
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
                          await _updateTask(tache, widget.tache.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tâche Validée')));
                          Navigator.pop(context);
                        }
                        catch(error){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opération Echouée')));
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Rectifier la tâche'),
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Ajouter une description',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer un titre';
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
                                    ElevatedButton(
                                      child: const Text('Soumettre'),
                                      onPressed: () {
                                        String desc = _descriptionController
                                            .text
                                            .toString();
                                        if (_descriptionController.text
                                            .toString()
                                            .isEmpty) {
                                          desc = widget.tache.description ?? "";
                                        }
                                        Tache tache = Tache(
                                            titre: widget.tache.titre,
                                            description: desc,
                                            type: "rectification",
                                            statut: false,
                                            etat: false);
                                        _updateTask(tache, widget.tache.id!);
                                        setState(() {});
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Tâche rectifiée avec succès')));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
                            "Réctifier",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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
