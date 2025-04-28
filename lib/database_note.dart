import 'dart:async';

import 'package:floor/floor.dart';
import 'notes.dart';
import 'note_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database_note.g.dart';

@Database(version: 1, entities: [Note])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
}
