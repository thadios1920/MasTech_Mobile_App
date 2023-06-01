import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/tache.dart';
import 'affectedTask_controller.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateFinController = TextEditingController();

  var _selectedChefChantier;

  late DateTime _selectedDate = DateTime(2022);
  final AffectedTaskController affectedTaskController =
      Get.put(AffectedTaskController());

  @override
  Widget build(BuildContext context) {
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
                  minLines: 1,
                  maxLines: 7,
                  maxLength: 200,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Date de fin',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Choisir une date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) {
                    if (e != null) {
                      if (e.isBefore(DateTime.now())) {
                        return "Veuillez sélectionner une date à partir d'aujourd'hui";
                      }
                    }
                    return null;
                  },
                  initialDate: DateTime.now(),
                  firstDate: DateTime
                      .now(), // Définit la première date disponible comme aujourd'hui
                  onDateSelected: (DateTime value) {
                    DateFormat('yyyy-MM-dd').format(value);
                    _selectedDate = value;
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
                    Obx(
                      () => DropdownButton<String>(
                        hint: const Text("Choisissez un chef"),
                        value: _selectedChefChantier,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedChefChantier = newValue!;
                          });
                        },
                        items: affectedTaskController.chefChantiersList
                            .where((chefChantier) => chefChantier.nom != null)
                            .map<DropdownMenuItem<String>>((chefChantier) {
                          return DropdownMenuItem<String>(
                            value: chefChantier.id.toString(),
                            child: Text(chefChantier.nom!),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _selectedChefChantier != null &&
                          _selectedDate != null) {
                        Tache tache = Tache(
                          titre: _titreController.text.toString(),
                          description: _descriptionController.text.toString(),
                          type: "nouveau",
                          statut: false,
                          etat: false,
                          dateFin: _selectedDate.toString(),
                        );
                        await affectedTaskController.createTask(
                            tache, _selectedChefChantier);
                        setState(() {});
                        Navigator.pop(
                            context); // retourne la nouvelle tâche à la page précédente
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Tâche ajoutée avec succès')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Veuillez remplir tous les champs obligatoires')),
                        );
                      }
                    },
                    child: const Text('Ajouter Tâche'),
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
