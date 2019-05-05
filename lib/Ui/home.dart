import 'package:firebase_example/Ui/Books.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SafeArea(child: Books(),),
      ),
    );
  //   Future<bool> _requestPop() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text("میخوای خارج بشی؟?"),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () => Navigator.pop(context, true),
  //                   child: Text("Yes")),
  //               FlatButton(
  //                   onPressed: () => Navigator.pop(context, false),
  //                   child: Text("No"))
  //             ],
  //           ));
  // }
  }
}



