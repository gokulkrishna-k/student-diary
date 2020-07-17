class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _catagorey;

  Note(this._title, this._date, this._catagorey, [this._description]);
  Note.withId(this._id, this._title, this._date, this._catagorey,
      [this._description]);
//GETTER
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get catagorey => _catagorey;
//SETTER
  set title(String newTitle) {
    if (newTitle.length <= 225) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 225) {
      this._description = newDescription;
    }
  }

  set catagorey(int newCatagorey) {
    if (newCatagorey >= 1 && newCatagorey <= 3) {
      this._catagorey = newCatagorey;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String,dynamic> toMap() {

    var map = Map<String, dynamic> ();
    if(id == null){
    map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['catagorey'] = _catagorey;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date =  map['date'];
    this._catagorey = map['catagorey'];

  }



}
