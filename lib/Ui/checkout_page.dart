import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Utils/primary_button.dart';
import 'package:firebase_example/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final sumPrice;

  CheckoutPage({Key key, this.sumPrice}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _customerName = "";
  String _fullAddress = "";
  final favoriteBooks =
      Firestore.instance.collection("favoriteBooks").snapshots();
  var docRef = Firestore.instance.collection('shoppingCart');
  final formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نهایی کردن سفارش"),
      ),
      key: _scaffoldKey,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: new Key('customerName'),
                  decoration:
                      new InputDecoration(labelText: 'نام و نام خانوادگی'),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.isEmpty ? 'این فیلد باید پر شود' : null,
                  onSaved: (val) => _customerName = val,
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: new Key('fullAddress'),
                  decoration: new InputDecoration(labelText: 'آدرس کامل'),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.isEmpty ? 'این فیلد باید پر شود' : null,
                  onSaved: (val) => _fullAddress = val,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("مبلغ کل"),
                  Text(widget.sumPrice.toString())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    Firestore.instance.collection("favoriteBooks").snapshots(),
                builder: (context, snapshotss) {
                  if (snapshotss.hasData) {
                    return Column(
                        children: snapshotss.data.documents
                            .map((doc) => buildScaffold(doc))
                            .toList());
                  } else
                    return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  PrimaryButton buildScaffold(DocumentSnapshot doc) {
    return PrimaryButton(
      text: "ارسال سفارش به درب منزل",
      onPressed: () async {
        final form = formKey.currentState;
        print("before form validation");
        if (form.validate()) {
          print("after form validation");
          form.save();
          favoriteBooks.listen((snapShot) async {
            for (int i = 0; i < snapShot.documents.length; i++) {
              await docRef.add({
                "book price": snapShot.documents[i].data['book price'],
                "book name": snapShot.documents[i].data['book name'],
                "book author": snapShot.documents[i].data['book author'],
                "book image": snapShot.documents[i].data['book image'],
                "book publisher": snapShot.documents[i].data['book publisher'],
                "fullAddress": _fullAddress,
                "customerName": _customerName,
              });
              
            }
            Firestore.instance
                  .collection("favoriteBooks")
                  .document(doc.documentID)
                  .delete();
          });

          Future.delayed(Duration(milliseconds: 500), () {
            showDialog(
                context: _scaffoldKey.currentContext,
                builder: (BuildContext context) {
                  return MyAlertDialog(_scaffoldKey);
                });
          });
        }
      },
      height: 56,
    );
  }
}
