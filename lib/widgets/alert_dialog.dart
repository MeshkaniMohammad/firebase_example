import 'dart:math';
import 'package:firebase_example/text%20painter/rectangle_shape.dart';
import 'package:firebase_example/text%20painter/shape.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatefulWidget {
    final _myScaffoldKey;

  MyAlertDialog(this._myScaffoldKey);
  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();

}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final   _random = Random();
  final _textController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int _randomNumber = 10000000 + _random.nextInt(99999);
    return AlertDialog(
      title: Text("تایید پرداخت"),
      content: Scaffold(
     key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Container(
              width: 250,
              height: 50,
              color: Colors.redAccent,
              child: CustomPaint(
                painter: _Painter(_randomNumber.toString()),
              )),
          RaisedButton(child:Text("تصویر جدید"),onPressed: (){
            setState(() {
                _randomNumber = 10000000 + _random.nextInt(99999);
              });
          },),
          Directionality(
            textDirection: TextDirection.rtl,
                      child: TextField(
              controller: _textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "متن مشاهده شده در تصویر را وارد کنید",
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (_textController.text == _randomNumber.toString()) {
                final _snackBar = SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Text(
                        "پرداخت با موفقیت انجام شد",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 1),
                    );

                    Future.delayed(Duration(milliseconds: 500), () {
                      widget._myScaffoldKey.currentState.showSnackBar(_snackBar);
                    });
              } else
                setState(() {
                  _randomNumber = 10000000 + _random.nextInt(99999);
                });
                Navigator.pop(context);
            },
            child: Text("ثبت نهایی"),
            color: Colors.blue,
          )
        ],
      ),
    ),
    );
  }
}

class _Painter extends CustomPainter {
  final String text;

  _Painter(this.text);
  @override
  void paint(Canvas canvas, Size size) {
    Shape shape;
    shape = RectangleShape();
    shape.draw(canvas, size, text);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
