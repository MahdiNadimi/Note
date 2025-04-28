import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_note.dart';
import 'package:flutter_application_1/note_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('note_database.db').build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اپلیکیشن یادداشت',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesPage(database: database),
    );
  }
}
