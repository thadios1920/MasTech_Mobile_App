import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/models/chefChantier.dart';
import 'package:pfe_mobile_app/models/tache.dart';

import '../../services/api_Client.dart';

class CreateTask extends StatefulWidget {
  final idChantier;
  const CreateTask({super.key, required this.idChantier});

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  List<ChefChantier> chefChantiers = [];

  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _selectedChefChantier;

  @override
  void initState() {
    super.initState();
    getChefChantiers();
  }

  Future<void> getChefChantiers() async {
    chefChantiers = await ApiClient.getChefChantier('/chefchantiers');

    if (chefChantiers.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Methode pour ajouter une tache
    createTask(Tache tache, idChef) async {
      await ApiClient.ajouterTache(
          '/taches/$idChef/${widget.idChantier}', tache);
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter Tache"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Titre',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _titreController,
                  decoration: const InputDecoration(
                    hintText: 'Enter le titre de la tache',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Entrer la description du tache',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chef Chantier',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      hint: const Text("Choisissez un chef"),
                      value: _selectedChefChantier,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedChefChantier = newValue!;
                        });
                      },
                      items: chefChantiers
                          .where((chefChantier) => chefChantier.nom != null)
                          .map<DropdownMenuItem<String>>((chefChantier) {
                        return DropdownMenuItem<String>(
                          value: chefChantier.id.toString(),
                          child: Text(chefChantier.nom!),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Tache tache = Tache(
                            titre: _titreController.text.toString(),
                            description: _descriptionController.text.toString(),
                            type: "nouveau",
                            statut: false,
                            etat: false);
                        await createTask(tache, _selectedChefChantier);
                        setState(() {});
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tâche ajoutée avec succès')));
                      }
                    },
                    child: const Text('Ajouter Tache'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
