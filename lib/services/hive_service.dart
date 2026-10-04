import 'package:hive_flutter/hive_flutter.dart';

import '../models/note_model.dart';

class HiveService {
  static const String boxName = 'notesBox';

  static Box<NoteModel> get box {
    return Hive.box<NoteModel>(boxName);
  }

  static Future<void> addNote(NoteModel note) async {
    final key = await box.add(note);

    await box.flush();

    print('NOTE SAVED');
    print('Key: $key');
    print('Notes count: ${box.length}');
  }

  static Future<void> updateNote(NoteModel note) async {
    await note.save();
    await box.flush();

    print('NOTE UPDATED');
    print('Notes count: ${box.length}');
  }

  static Future<void> deleteNote(NoteModel note) async {
    await note.delete();
    await box.flush();
  }

  static Future<void> deleteAllNotes() async {
    await box.clear();
    await box.flush();
  }

  static Future<void> togglePin(NoteModel note) async {
    note.isPinned = !note.isPinned;

    await note.save();
    await box.flush();
  }

  static List<NoteModel> getNotes() {
    return box.values.toList();
  }
}