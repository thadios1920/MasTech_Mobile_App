import 'package:get/get.dart';

import 'note_controller.dart';

class NoteBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteController>(() => NoteController(), tag: 'note');
  }
}
