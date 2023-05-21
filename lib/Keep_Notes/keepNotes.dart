import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Note {
  final String title;
  final String text;
  final DateTime dateTime;

  Note({
    required this.title,
    required this.text,
    required this.dateTime,
  });
}

class Todo {
  final String task;
  bool isDone;

  Todo({
    required this.task,
    this.isDone = false,
  });
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late SharedPreferences _preferences;
  final TextEditingController _titleInputController = TextEditingController();
  final TextEditingController _textInputController = TextEditingController();
  List<Note> _notes = [];
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      final notesData = _preferences.getStringList('notes');
      _notes = notesData != null
          ? notesData
              .map((noteData) => Note(
                    title: noteData.split(',')[0],
                    text: noteData.split(',')[1],
                    dateTime: DateTime.parse(noteData.split(',')[2]),
                  ))
              .toList()
          : [];

      final todosData = _preferences.getStringList('todos');
      _todos = todosData != null
          ? todosData
              .map((todoData) => Todo(
                    task: todoData.split(',')[0],
                    isDone: todoData.split(',')[1] == 'true',
                  ))
              .toList()
          : [];
    });
  }

  Future<void> _saveData() async {
    final notesData = _notes
        .map((note) =>
            '${note.title},${note.text},${note.dateTime.toIso8601String()}')
        .toList();
    await _preferences.setStringList('notes', notesData);

    final todosData =
        _todos.map((todo) => '${todo.task},${todo.isDone}').toList();
    await _preferences.setStringList('todos', todosData);
  }

  void _addNote() {
    final title = _titleInputController.text;
    final text = _textInputController.text;
    final dateTime = DateTime.now();

    if (title.isNotEmpty && text.isNotEmpty) {
      setState(() {
        _notes.add(Note(
          title: title,
          text: text,
          dateTime: dateTime,
        ));
        _titleInputController.clear();
        _textInputController.clear();
      });

      _saveData();
    }
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });

    _saveData();
    _undoDeleteNote();
  }

  final int _deletedNoteIndex = 0;
  late Note _deletedNote;

  void _undoDeleteNote() {
    if (_deletedNote != null && _deletedNoteIndex != null) {
      setState(() {
        _notes.insert(_deletedNoteIndex!, _deletedNote as Note);
      });

      _saveData();
    }
  }

  void _deleteNoteWithUndo(int index) {
    setState(() {
      _notes.removeAt(index);
    });

    _saveData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _undoDeleteNote();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return Dismissible(
                  key: Key(note.dateTime.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteNoteWithUndo(index);
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title.upperCamelCase,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.text,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Created on: ${DateFormat('dd-MM-yy && HH:mm:ss').format(note.dateTime)} \n ',
                          style: TextStyle(
                              fontSize: 14, color: Colors.green.shade600),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(note.title),
                          content: Text(note.text),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade600),
                              ),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'To-Do List',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.green.shade800),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _titleInputController,
                  decoration: InputDecoration(
                    labelText: 'Enter note title',
                    labelStyle: TextStyle(color: Colors.green.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _textInputController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter note text',
                    labelStyle: TextStyle(color: Colors.green.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade600),
                  ),
                  child: Text(
                    'Add Note',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _todos.length,
                  itemBuilder: (ctx, index) {
                    final todo = _todos[index];
                    return ListTile(
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) => _toggleTodoStatus(index),
                      ),
                      title: Text(todo.task),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _textInputController.dispose();
    super.dispose();
  }
}
