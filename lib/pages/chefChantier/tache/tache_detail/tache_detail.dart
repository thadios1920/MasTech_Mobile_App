
import 'package:flutter/material.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/tache_detail/widgets/tache_description.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/tache_detail/widgets/tache_image.dart';
import 'package:pfe_mobile_app/pages/chefChantier/tache/tache_detail/widgets/Tacheheader.dart';
import '../../../../models/tache.dart';
import '../../../../services/api_Client.dart';

class TacheDetail extends StatefulWidget {
  final Tache tache;
  TacheDetail({required this.tache});

  @override
  State<TacheDetail> createState() => _TacheDetailState();
}

class _TacheDetailState extends State<TacheDetail> {


  @override
  void initState() {
    super.initState();
  }
  Future<void> _updateTask(Tache tache, int idTask) async {
    await ApiClient.modifierTache('/taches/$idTask', tache);
    setState(() {});
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
      body: Container(

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25.0,
              ),
              Tacheheader(tache: tache),
              SizedBox(
                height: 50.0,
              ),
              TacheImage(),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0),
                child:TextField(
                    readOnly: true,
                    controller: textarea,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.black),
                      hintText: "Description:\n${tache.description}",

                    )
                ),
              ),

              TacheDescription(tache: tache),
              SizedBox(
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
                              etat: false);
                          try {
                            await _updateTask(tache, widget.tache.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tâche Terminée')));
                            Navigator.pop(context);
                          }
                          catch(error){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opération Echouée')));
                          }
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              "Terminer",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                        ),

                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
