import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookDescription extends StatefulWidget {
  final String _bookImage;
  final String _bookName;
  final String _bookAuthor;
  final int _bookPrice;
  final String _bookPublisher;
  final int _quantity;
  final int _index;
  final List<DocumentSnapshot> documents;

  BookDescription(
      this._bookImage,
      this._bookAuthor,
      this._bookName,
      this._bookPrice,
      this._bookPublisher,
      this._quantity,
      this._index,
      this.documents);

  @override
  BookDescriptionState createState() => BookDescriptionState();
}

class BookDescriptionState extends State<BookDescription> {
    
  final _key = GlobalKey<ScaffoldState>();
int _quantity ;
int _addedToCart = 0;
@override
  void initState() {
     _quantity = widget._quantity - 1; 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("توضیحات کتاب"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              widget._bookImage,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget._bookName),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(":نام کتاب"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget._bookAuthor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(":نویسنده کتاب"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget._bookPrice.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(":قیمت کتاب"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget._bookPublisher),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(":ناشر"),
                ),
              ],
            ),
          ),
        
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: (){
          if (widget._quantity > 0) {
                                
                    final _doneSnackBar = SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text(
                        "کتاب شما به سبد خرید اضافه شد",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 1),
                    );

                    setState(() {
                     _addedToCart++; 
                    });
                    
                    Future.delayed(Duration(milliseconds: 500), () {
                      _key.currentState.showSnackBar(_doneSnackBar);
                    setState(() {
                     _quantity = widget._quantity - _addedToCart; 
                    });
                    });

                    List<DocumentSnapshot> documents = widget.documents;

                    Firestore.instance
                        .runTransaction((Transaction transaction) async {
                      DocumentSnapshot snapshot = await transaction
                          .get(documents[widget._index].reference);
                      await transaction.update(snapshot.reference, {
                        "quantity": _quantity,
                      });
                    });
                    final docRef = Firestore.instance
                        .collection('favoriteBooks')
                        .document();
                    docRef.setData({
                      "book price": widget._bookPrice,
                      "book name": widget._bookName,
                      "book author": widget._bookAuthor,
                      "book image": widget._bookImage,
                      "book publisher": widget._bookPublisher,
                    });
                    
                  } else {
                    final _errorSnackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "کتاب مورد نظر موجود نیست",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 1),
                    );
                    Future.delayed(Duration(seconds: 1), () {
                      _key.currentState.showSnackBar(_errorSnackBar);
                    });
                  }
        },
        icon: Icon(Icons.add),
        label: Text("افزودن به سبد خرید"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
