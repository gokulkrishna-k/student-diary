import 'package:flutter/material.dart';
import 'package:work_manager/models/note.dart';
import 'package:work_manager/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  static var _catagorey = ['Assignment', 'Record', 'Others'];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBarTitle;
  var _formKey = GlobalKey<FormState>();

  DatabaseHelper helper = DatabaseHelper();
  Note note;
  _NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  DropdownButton(
                    items: _catagorey.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getCatagoreyAsString(note.catagorey),
                    onChanged: (value) {
                      setState(() {
                        updateCatagoreyAsInt(value);
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "* Please Enter a title";
                        }
                        
                      },
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: TextFormField(
                      maxLines: 4,
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.15,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  _save();
                                }
                              });
                            },
                          ),
                        ),
                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.15,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  void updateCatagoreyAsInt(String value) {
    switch (value) {
      case 'Assignment':
        note.catagorey = 1;
        break;
      case 'Record':
        note.catagorey = 2;
        break;
      case 'Others':
        note.catagorey = 3;
        break;
    }
  }

  String getCatagoreyAsString(int value) {
    String catagorey;
    switch (value) {
      case 1:
        catagorey = _catagorey[0];
        break;
      case 2:
        catagorey = _catagorey[1];
        break;
      case 3:
        catagorey = _catagorey[2];
        break;
    }
    return catagorey;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog("Status", "Task Saved Successfully");
    } else {
      _showAlertDialog("Status", "Problem While Saving Task!");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog("Status", "No Task was deleted");
      return;
    }

    int result = await helper.deleteNote(note.id);

    if (result != 0) {
      _showAlertDialog("Status", 'Task Deleted Successfully');
    } else {
      _showAlertDialog("Status", 'Error Occured while Deleting Task');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
