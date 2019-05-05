import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Utils/primary_button.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  static final formKey = new GlobalKey<FormState>();
  final sumPrice;
  CheckoutPage({Key key, this.sumPrice}) : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _customerName = "";
  String _fullAddress = "";
  static final formKey = CheckoutPage.formKey;
  static final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                  validator: (val) => val.isEmpty ? 'این فیلد باید پر شود' : null,
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
                  validator: (val) => val.isEmpty ? 'این فیلد باید پر شود' : null,
                  onSaved: (val) => _fullAddress = val,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("مبلغ کل"), Text(widget.sumPrice.toString())],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                text: "ارسال سفارش به درب منزل",
                onPressed: () async {
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    Firestore.instance
                        .collection("favoriteBooks")
                        .snapshots()
                        .listen((snapShot) {
                      snapShot.documents.forEach((doc) {
                        final docRef = Firestore.instance
                            .collection('shoppingCart')
                            .document();
                        docRef.setData({
                          "book price": doc.data['book price'],
                          "book name": doc.data['book name'],
                          "book author": doc.data['book author'],
                          "book image": doc.data['book image'],
                          "book publisher": doc.data['book publisher'],
                          "fullAddress": _fullAddress,
                          "customerName": _customerName,
                        });
                      });
                    });
                    final _snackBar = SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text(
                        "سفارش با موفقیت ثبت شد",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 1),
                    );

                    Future.delayed(Duration(milliseconds: 500), () {
                      _scaffoldKey.currentState.showSnackBar(_snackBar);
                    });
                  }
                },
                height: 56,
              ),
            )
          ],
        ),
      ),
    );
  }
}
