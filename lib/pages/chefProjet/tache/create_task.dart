import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pfe_mobile_app/models/chefChantier.dart';
import 'package:pfe_mobile_app/models/tache.dart';
import 'package:date_field/date_field.dart';
import '../../../services/api_Client.dart';

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
  final _dateFinController = TextEditingController();

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

  late DateTime _selectedDate = DateTime(2022);

  @override
  Widget build(BuildContext context) {
    // Methode pour ajouter une tache
    Future<Tache> createTask(Tache tache, idChef) async {
      Tache createdTask = await ApiClient.ajouterTache(
          '/taches/$idChef/${widget.idChantier}', tache);
      setState(() {});
      return createdTask;
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
                      if (_formKey.currentState!.validate() &&
                          _selectedChefChantier != null) {
                        Tache tache = Tache(
                            titre: _titreController.text.toString(),
                            description: _descriptionController.text.toString(),
                            type: "nouveau",
                            statut: false,
                            etat: false,
                            dateFin: _selectedDate.toString());
                        Tache tacheCreee =
                            await createTask(tache, _selectedChefChantier);
                        setState(() {});
                        Navigator.pop(context,
                            tacheCreee); // retourne la nouvelle tâche à la page précédente

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tâche ajoutée avec succès')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Champs invalide !!')));
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
