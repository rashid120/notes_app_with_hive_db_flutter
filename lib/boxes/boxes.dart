

import 'package:hive/hive.dart';
import 'package:notes_app_hive_db/models/notes_model.dart';

class Boxes{

  // get box from NotesModel
  static Box<NotesModel> getData() => Hive.box<NotesModel>('myNotes');
}