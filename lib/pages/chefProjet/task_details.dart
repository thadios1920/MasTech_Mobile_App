import 'package:flutter/material.dart';

import '../../models/tache.dart';
import '../../services/api_client.dart';

class TodoDetailsPage extends StatefulWidget {
  final int idTask;
  final String title;
  final String description;
  final String type;
  final bool etat;
  final bool statut;
  final String createdAt;
  final String updatedAt;

  TodoDetailsPage({
    required this.idTask,
    required this.title,
    required this.description,
    required this.type,
    required this.etat,
    required this.statut,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  _TodoDetailsPageState createState() => _TodoDetailsPageState();
}

class _TodoDetailsPageState extends State<TodoDetailsPage> {
  final _descriptionController = TextEditingController();
  String _taskNotes = "";

  Future<void> _updateTask(Tache tache, int idTask) async {
    await ApiClient.modifierTache('/taches/$idTask', tache);
    setState(() {});
  }

  Widget _buildTextWithFontSize(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Widget _buildRowWithTwoColumns(String leftText, String rightText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextWithFontSize(leftText, 16),
        _buildTextWithFontSize(rightText, 16),
      ],
    );
  }

  Widget _buildSectionWithTitle(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextWithFontSize(title, 24),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTaskDetailsSection() {
    return _buildSectionWithTitle(
      'Détails de la tâche :',
      [
        _buildTextWithFontSize(widget.description, 24),
        const SizedBox(height: 32),
        _buildRowWithTwoColumns('Type :', widget.type),
        _buildRowWithTwoColumns(
          'Etat :',
          widget.etat ? 'Terminée' : 'En cours',
        ),
        _buildRowWithTwoColumns(
          'Statut :',
          widget.statut ? 'Validé' : 'Non validé',
        ),
        _buildRowWithTwoColumns('Créé le :', widget.createdAt),
        _buildRowWithTwoColumns('Mis à jour le :', widget.updatedAt),
      ],
    );
  }

  Widget _buildTaskActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Rectifier la tâche'),
                    content: Form(
                      child: Column(
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
                            onPressed: () async {
                              String desc =
                                  _descriptionController.text.toString();
                              if (_descriptionController.text
                                  .toString()
                                  .isEmpty) {
                                desc = widget.description;
                              }
                              Tache tache = Tache(
                                  titre: widget.title,
                                  description: desc,
                                  type: "rectification",
                                  statut: false,
                                  etat: false);
                              await _updateTask(tache, widget.idTask);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Rectifier'),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              Tache tache = Tache(
                  titre: widget.title,
                  description: widget.description,
                  type: widget.type,
                  statut: true,
                  etat: widget.etat);
              await _updateTask(tache, widget.idTask);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Valider"),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Supprimer la tâche'),
                    content: const Text(
                        'Êtes-vous sûr(e) de vouloir supprimer cette tâche ?'),
                    actions: [
                      TextButton(
                        child: const Text('Annuler'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Supprimer'),
                        onPressed: () async {
                          // await ApiClient.supprimerTache(
                          //     '/taches/${widget.idTask}');
                          // Navigator.pop(context);
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Supprimer'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskDetailsSection(),
            _buildTaskActionButtons(),
          ],
        ),
      ),
    );
  }
}
