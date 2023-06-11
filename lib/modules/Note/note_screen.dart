import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'note_controller.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              noteController.noteText.value,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          noteController.noteText.value = value;
                        });
                      },
                      autofocus: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Écrivez votre note...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
