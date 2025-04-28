import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_note.dart';
import 'package:flutter_application_1/notes.dart';

class NotesPage extends StatefulWidget {
  final AppDatabase database;

  const NotesPage({Key? key, required this.database}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    _notesFuture = widget.database.noteDao.findAllNotes();
  }

  Future<void> _addNoteDialog() async {
    String title = '';
    String content = '';

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Subject'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Content'),
                  onChanged: (value) => content = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final newNote = Note(title: title, content: content);
                    await widget.database.noteDao.insertNote(newNote);
                    setState(() {
                      _loadNotes();
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Future<void> _editNoteDialog(Note note) async {
    String title = note.title;
    String content = note.content;

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: title),
                  decoration: const InputDecoration(labelText: 'Subject'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  controller: TextEditingController(text: content),
                  decoration: const InputDecoration(labelText: 'Content'),
                  onChanged: (value) => content = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final updatedNote = Note(
                      id: note.id,
                      title: title,
                      content: content,
                    );
                    await widget.database.noteDao.updateNote(updatedNote);
                    setState(() {
                      _loadNotes();
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save note'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteNote(Note note) async {
    await widget.database.noteDao.deleteNote(note);
    setState(() {
      _loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyan, title: const Text('Nots ')),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('There is No content'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    onTap: () => _editNoteDialog(note),
                    trailing: SizedBox(
                      width: MediaQuery.sizeOf(context).width / 4,
                      height: 25,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _editNoteDialog(note),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(note),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
