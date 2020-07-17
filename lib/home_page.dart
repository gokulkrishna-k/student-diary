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
    if ( noteList == null ){
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
        
        appBar: AppBar(
          title: Text("Task List"),

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
          
          color: Theme.of(context).primaryColorDark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.add),
              Container(width: 10,),
              Text("Add Task"),

            ],
          ),
          onPressed: () {
navigateToDetail(Note("","",3),'Add Task');
          },
        ),
            ),
          ],
        ),
    
        body: 
getNoteListView());
  }

  ListView getNoteListView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Theme.of(context).cardColor,
            elevation: 2.0,
            child: ListTile(
              leading: Icon(
                getCatagoreyIcon(this.noteList[position].catagorey),
                color: getCatagoreyColor(this.noteList[position].catagorey),
                size: 25 ,
              ),
              title: Text(this.noteList[position].title, style: titlestyle),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector(
              child:Icon(Icons.delete, color: Colors.grey),
              onTap: (){
                _delete(context, noteList[position]);
              },
              ),
              onTap: ()  {
                navigateToDetail(this.noteList[position],'Edit Task');

          },
            ),
          );
        });
  }
  Color getCatagoreyColor(int catagorey) {
    switch(catagorey) {
      case 1:
      return Colors.red;break;
      case 2:
      return Colors.green;break;
      case 3:
      return Colors.indigo;break;
      default:
      return Colors.indigo;
    }
  }

    IconData getCatagoreyIcon(int catagorey) {
    switch(catagorey) {
      case 1:
      return Icons.assignment;break;
      case 2:
      return Icons.library_books;break;
      case 3:
      return Icons.note;break;
      default:
      return Icons.note;break;
    }
  }

  void _delete (BuildContext context ,Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if(result !=0) {
      _showSnackBar(context, 'Task Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
  }



  void navigateToDetail(Note note, String title) async{
               bool result =  await Navigator.push(context, MaterialPageRoute(builder: (context){
              return NoteDetail(note, title);
            }));
            if(result == true){
              updateListView();
            }
  }

  void updateListView() {


    final Future<Database> dbFuture = databaseHelper.intializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();

      noteListFuture.then((noteList){
        setState(() {
          this.noteList =noteList;
          this.count = noteList.length;
        });
      });
    }

    );
  }
}
