import 'package:flutter/material.dart';
import 'package:work_manager/create_task.dart';
import 'dart:async';
import 'package:work_manager/models/note.dart';
import 'package:work_manager/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Student Diary",
              style: TextStyle(
                  letterSpacing: 1,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromRGBO(2, 28, 51, 1))),
          backgroundColor: Color.fromRGBO(241, 244, 251, 1),
        ),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            child: Icon(
              Icons.edit,
              color: Color.fromRGBO(2, 28, 51, 1),
              size: 26,
            ),
            backgroundColor: Color.fromRGBO(195, 231, 255, 1),
            onPressed: () {
              navigateToDetail(Note("", "", 3), 'Add Task');
            }),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: getNoteListView(),
        ));
  }

  ListView getNoteListView() {
    // TextStyle titlestyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
            child: Card(
              color: Theme.of(context).cardColor,
              elevation: 2.0,
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Icon(
                    getCatagoreyIcon(this.noteList[position].catagorey),
                    color: getCatagoreyColor(this.noteList[position].catagorey),
                    size: 24,
                  ),
                ),
                title: Text(this.noteList[position].title,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  this.noteList[position].date,
                  style: TextStyle(fontFamily: "Poppins"),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(62, 66, 67, 1),
                    size: 26,
                  ),
                  onTap: () {
                    _delete(context, noteList[position]);
                  },
                ),
                onTap: () {
                  navigateToDetail(this.noteList[position], 'Edit Task');
                },
              ),
            ),
          );
        });
  }

  Color getCatagoreyColor(int catagorey) {
    switch (catagorey) {
      case 1:
        return Colors.orange[400];
        break;
      case 2:
        return Colors.green[400];
        break;
      case 3:
        return Colors.red[400];
        break;
      default:
        return Colors.red[400];
    }
  }

  IconData getCatagoreyIcon(int catagorey) {
    switch (catagorey) {
      case 1:
        return Icons.assignment;
        break;
      case 2:
        return Icons.library_books;
        break;
      case 3:
        return Icons.event_note;
        break;
      default:
        return Icons.event_note;
        break;
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.intializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();

      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
