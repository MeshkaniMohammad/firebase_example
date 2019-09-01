import 'dart:ui';

import 'package:flutter/rendering.dart' as prefix0;
import 'package:flutter/widgets.dart';

abstract class Shape{

  void draw(Canvas canvas, Size size,String text);

  drawText(Canvas canvas,String text) {
    TextSpan textSpan = TextSpan(text: text,style: prefix0.TextStyle(fontSize: 29,letterSpacing: 10));
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(0,0),
    );
  }
}