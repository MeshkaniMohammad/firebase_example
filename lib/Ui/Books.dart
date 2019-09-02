import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Ui/book_store_owner_cart.dart';
import 'package:firebase_example/Ui/firestore-listview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart';

class Books extends StatefulWidget {
  @override
  BooksState createState() => BooksState();
}

class BooksState extends State<Books> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("کتاب فروشی آقای ایکس"),
        actions: <Widget>[
          Container(
            height: 50,
            width: 40,
            child: StreamBuilder(
                stream:
                    Firestore.instance.collection('shoppingCart').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return BadgeIconButton(
                      icon: Icon(Icons.shopping_cart),
                      itemCount: snapshot?.data?.documents?.length == 0
                          ? 0
                          : snapshot?.data?.documents?.length,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BookStroreOwnerCart())),
                    );
                  } else {
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }
                }),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3366FF),
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: _showAlertDialog),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
        child: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [const Color(0xFF3366FF), const Color(0xFF00CCFF)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 0.5],
                tileMode: TileMode.clamp),
          ),
          height: 50.0,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: StreamBuilder(
            stream: Firestore.instance.collection('books').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return FireStoreListView(documents: snapshot.data.documents);
            }),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (_) => BookUploadDialog(),
    );
  }
}

class BookUploadDialog extends StatefulWidget {
  @override
  _BookUploadDialogState createState() => _BookUploadDialogState();
}

class _BookUploadDialogState extends State<BookUploadDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _bookName = '';
  String _bookAuthor = '';
  File _imageFile;
  int _quantity = 0;
  String _publisher = "";
  int _price = 0;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                validator: (val) => val.isEmpty
                                    ? "افزودن نام کتاب ضروری است!"
                                    : null,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: "افزودن کتاب",
                                    hintText: "نام کتاب را وارد کنید"),
                                onSaved: (String value) => _bookName = value,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                validator: (val) => val.isEmpty
                                    ? "افزودن نام نویسنده ضروری است!"
                                    : null,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: "نویسنده کتاب",
                                    hintText: "نام نویسنده کتاب را وارد کنید"),
                                onSaved: (String value) => _bookAuthor = value,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                validator: (val) => val.isEmpty
                                    ? "افزودن ناشر کتاب ضروری است!"
                                    : null,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: "ناشر کتاب",
                                    hintText: "نام ناشر را وارد کنید"),
                                onSaved: (String value) => _publisher = value,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val.isEmpty || int.parse(val) < 0
                                        ? "لطفا عددی صحیح و مثبت وارد کنید"
                                        : null,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: "قیمت کتاب",
                                    hintText: "قیمت کتاب را وارد کنید"),
                                onSaved: (value) => _price = int.parse(value),
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val.isEmpty || int.parse(val) < 0
                                        ? "لطفا عددی صحیح و مثبت وارد کنید"
                                        : null,
                                textAlign: TextAlign.right,
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: "موجودی کتاب",
                                    hintText: "تعداد موجودی کتاب مورد نظر"),
                                onSaved: (value) => _quantity = int.parse(value),
                              ),
                            ),
                          ],
                        )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: FlatButton(
                  color: Colors.blueAccent,
                  onPressed: _handleImagePicker,
                  child: Text("عکس گرفتن از کتاب")),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                  color: Colors.blueAccent,
                  onPressed: _handleImagePickerGallery,
                  child: Text("انتخاب از گالری")),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: _handleSubmit,
          child: Text("ذخیره کتاب"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("لغو"),
        ),
      ],
    );
  }

  void _handleImagePicker() {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File file) => _imageFile = file);
  }

  void _handleImagePickerGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery)
        .then((File file) => _imageFile = file);
  }

  Future<Null> _handleSubmit() async {
    _formKey.currentState.save();

    setState(() => _isLoading = true);

    final docRef = Firestore.instance.collection('books').document();
    final uploadTask = FirebaseStorage.instance
        .ref()
        .child('books/${docRef.documentID}')
        .putFile(_imageFile);
    final fileUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();

    await docRef.setData({
      "book name": _bookName,
      "book author": _bookAuthor,
      "book image": fileUrl.toString(),
      "book publisher": _publisher,
      "book price": _price,
      "quantity": _quantity,
      "book name searchkey":_bookName[0],
      "book author searchkey":_bookAuthor[0],
      "book publisher searchkey":_publisher[0],
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
