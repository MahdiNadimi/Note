import 'package:floor/floor.dart';

@entity
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});
}
