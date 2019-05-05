
class Book {
  String _bookName;
  String _bookAuthor;
  int _bookPrice;
  String _bookPublisher;
  int _id;

  Book( this._bookName, this._bookAuthor, this._bookPrice, this._bookPublisher,this._id);

  int get id => _id;

  String get bookPublisher => _bookPublisher;

  int get bookPrice => _bookPrice;

  String get bookAuthor => _bookAuthor;

  String get bookName => _bookName;


  
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id != null) map["id"] = _id;
    map["bookPrice"] = _bookPrice;
    map["bookName"] = _bookName;
    map["bookPublisher"] = _bookPublisher;
    map["bookAuthor"] = _bookAuthor;
    return map;
  }

  Book.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._bookPrice = map["bookPrice"];
    this._bookName = map["bookName"];
    this._bookPublisher = map["bookPublisher"];
    this._bookAuthor = map["bookAuthor"];
  }


}