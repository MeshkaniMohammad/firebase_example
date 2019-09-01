import 'dart:ui';

import 'package:firebase_example/text%20painter/shape.dart';



class RectangleShape extends Shape {


  @override
  void draw(Canvas canvas, Size size,String text) {
    
    canvas.drawRect(Rect.fromLTRB(0, 0, 0, 0),Paint());
    drawText(canvas,text);
  }
}