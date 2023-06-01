import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastech/modules/taches/ToDo/ToDoTask_screen/tache_detail/widgets/tache_description.dart';

import '../../../../../models/tache.dart';
import '../../../affected/affectedTask_screen/tache_detail/widgets/Tacheheader.dart';
import '../../../affected/affectedTask_screen/tache_detail/widgets/tache_image.dart';
import '../../../affectedTask_controller.dart';

class TacheDetail extends StatefulWidget {
  final Tache tache;
  const TacheDetail({super.key, required this.tache});

  @override
  State<TacheDetail> createState() => _TacheDetailState();
}

class _TacheDetailState extends State<TacheDetail> {
  final AffectedTaskController taskController =
      Get.put(AffectedTaskController());

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
            TacheImage(imageURL: tache.imageURL),
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
                        try {
                          await taskController.terminerTask(widget.tache.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tâche Terminée')));
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Opération Echouée')));
                        }
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
    );
  }
}
