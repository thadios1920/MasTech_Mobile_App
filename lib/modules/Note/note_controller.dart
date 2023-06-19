import 'package:get/get.dart';
import 'package:mastech/models/utilisateur.dart';
import 'package:mastech/modules/Note/note_service.dart';

import '../../helpers/shared_service.dart';
import '../../models/login_details.dart';

class NoteController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  var noteText = ''.obs;
  var auxNote = ''.obs;
  Utilisateur user = Utilisateur();

  getRole() async {
    LoginDetails details = await SharedService().getLoginDetails();
    user = details.user!;
  }

  fetchNotes() async {
    try {
      await getRole();
      var newNote = await NoteService.getNote('/accounts/${user.id}/note');
      noteText.value = noteText.value + newNote['note'].toString();
      print(noteText);
    } catch (e) {
      print(e);
    }
  }

  saveNote(String auNote) async {
    await NoteService().modifierNote('/accounts/${user.id}/note', auNote);
    noteText.value = auNote;
  }
}
