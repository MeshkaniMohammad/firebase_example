import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;

  FireStoreListView({this.documents});

  @override
  FireStoreListViewState createState() {
    return new FireStoreListViewState();
  }
}

class FireStoreListViewState extends State<FireStoreListView> {
  static List<DocumentSnapshot> documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.documents.length,
          itemBuilder: (BuildContext context, int index) {
            String bookName =
                widget.documents[index].data['book name'] as String;
            String bookAuthor =
                widget.documents[index].data['book author'] as String;
             String bookImageUrl =
                 widget.documents[index].data['book image'] as String;

            int _quantity = widget.documents[index].data["quantity"] as int;
            String bookPublisher =
                widget.documents[index].data["book publisher"] as String;
            int bookPrice = widget.documents[index].data["book price"] as int;
            documentSnapshot = widget.documents;
            return GestureDetector(
                child: Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            bookName,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 22),
                          )),
                        ),
                        Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Image.network("$bookImageUrl",width: 100,height: 150,scale: 0.5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "نویسنده: $bookAuthor",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("ناشر: $bookPublisher"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("قیمت:$bookPrice تومان"),
                              ),
                                  ],
                                ),
                              ],
                              ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _quantity.toString(),
                                style: TextStyle(
                                    fontSize: 22, color: Colors.redAccent),
                              ),
                              SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                      icon: Image.asset(
                                          "assets/icons/categories.png"),
                                      onPressed: null)),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset("assets/icons/shelf.png"),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                onLongPress: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return new _UpdateBookDialog(index);
                    },
                    //fullscreenDialog: true
                  ));
                },
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => _UpdateBookPrice(index),
                  );
                });
          }),
    );
  }
}

class _UpdateBookDialog extends StatefulWidget {
  _UpdateBookDialog(this.index);

  final int index;

  @override
  _BookUploadDialogState createState() => _BookUploadDialogState(index);
}

class _BookUploadDialogState extends State<_UpdateBookDialog> {
  _BookUploadDialogState(this.index);

  final int index;
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;

  List<DocumentSnapshot> documents = FireStoreListViewState.documentSnapshot;
  int _quantity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("به روز رسانی تعداد موجودی کتاب"),
      content: new Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Form(
                        key: _formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: "تعداد موجودی کتاب",
                                      hintText: "تعداد موجودی"),
                                  onSaved: (String value) =>
                                      _quantity = int.parse(value),
                                ),
                              ),
                            ),
                          ],
                        )),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.blueAccent,
          onPressed: _handleUpdateButton,
          child: Text(
            "به روز رسانی",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
        ),
        FlatButton(
          color: Colors.blueAccent,
          onPressed: () => Navigator.pop(context),
          child: Text(
            "لغو",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<Null> _handleUpdateButton() async {
    _formKey.currentState.save();

    setState(() => _isLoading = true);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(documents[index].reference);
      await transaction.update(snapshot.reference, {"quantity": _quantity});
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _UpdateBookPrice extends StatefulWidget {
  _UpdateBookPrice(this.index);

  final int index;

  @override
  _BookPriceState createState() => _BookPriceState(index);
}

class _BookPriceState extends State<_UpdateBookPrice> {
  _BookPriceState(this.index);

  final int index;
  final GlobalKey<FormState> _formKey = GlobalKey();

  int _bookPrice;

  bool _isLoading = false;

  List<DocumentSnapshot> documents = FireStoreListViewState.documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("به روز رسانی قیمت"),
      content: new Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Form(
                        key: _formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: "قیمت کتاب", hintText: "قیمت"),
                                  onSaved: (String value) =>
                                      _bookPrice = int.parse(value),
                                ),
                              ),
                            ),
                          ],
                        )),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.blueAccent,
          onPressed: _handleUpdateButton,
          child: Text(
            "به روز رسانی",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
        ),
        FlatButton(
          color: Colors.blueAccent,
          onPressed: () => Navigator.pop(context),
          child: Text(
            "لغو",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<Null> _handleUpdateButton() async {
    _formKey.currentState.save();

    setState(() => _isLoading = true);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(documents[index].reference);
      await transaction.update(snapshot.reference, {
        // "book image": fileUrl,
        "book price": _bookPrice
      });
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
