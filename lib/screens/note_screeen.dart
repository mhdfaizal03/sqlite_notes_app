import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite_database/models/note.dart';
import 'package:sqlite_database/services/database_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Note> notes = [];
  final controller = TextEditingController();
  final subController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    notes = await dbHelper.getNotes();
    setState(() {});
  }

  void addNote() async {
    final newNote = Note(
      title: controller.text,
      content: subController.text,
    );
    await dbHelper.addNote(newNote);
    loadNotes();
  }

  void updateNote(Note note) async {
    note.title = controller.text;
    await dbHelper.updateNote(note);
    loadNotes();
  }

  void deleteNote(Note note) async {
    await dbHelper.deleteNote(note.id!);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: subController,
                      decoration: const InputDecoration(
                        hintText: 'Enter data',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        addNote();
                        Navigator.pop(context);
                        controller.clear();
                        subController.clear();
                      },
                      child: const Text('Save')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Colors.blue,
            ),
            child: const Center(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  'SQLite in flutter',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter name',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: subController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter data',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        updateNote(note);
                                        Navigator.pop(context);
                                        controller.clear();
                                        subController.clear();
                                      },
                                      child: const Text('Save')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'))
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteNote(note);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
