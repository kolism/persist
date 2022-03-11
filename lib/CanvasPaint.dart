import 'dart:async';

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CanvasPaint extends CustomPainter {
  int _totalNodes = 0;
  BuildContext? _context;

  List<Path> getTree(){
    var out = <Path>[];
    String sentence = "F";
    for (var i = 0; i < sentence.length; i++) {
      var current = sentence[i];
      debugPrint("Current $current");
      
      if(current.toUpperCase() == "F"){
        var path = Path();
        path.moveTo(0.0,0);
        path.lineTo(50.0,50.0);
        path.lineTo(30.0,50.0);
        path.close();
        out.add(path);
      }
    }
    return out;
  }


  List<DoublePair> getTree2(){
    var out = <DoublePair>[];
    String sentence = "F";
    for (var i = 0; i < sentence.length; i++) {
      var current = sentence[i];
      debugPrint("Current $current");

      if(current.toUpperCase() == "F"){
        out.add(DoublePair(0.0,0.0,0.0,50.0));
      }
    }
    return out;
  }

  void _drawFilledCircle (Canvas canvas, centerX, centerY, radius)  {
    var x = Paint()
      ..color = Theme.of(_context!).colorScheme.secondary
      ..strokeWidth = 3;
    x.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, x);

  }
  double x = 0;
  double y = 0;
  _drawTree(Canvas canvas, Size size){
    var nextX = 0.0;
    var nextY = 0.0;
    var r = Random().nextDouble();

    if (r < 0.01) {
      nextX =  0;
      nextY =  0.16 * y;
    } else if (r < 0.86) {
      nextX =  0.85 * x + 0.04 * y;
      nextY = -0.04 * x + 0.85 * y + 1.6;
    } else if (r < 0.93) {
      nextX =  0.20 * x - 0.26 * y;
      nextY =  0.23 * x + 0.22 * y + 1.6;
    } else {
      nextX = -0.15 * x + 0.28 * y;
      nextY =  0.26 * x + 0.24 * y + 0.44;
    }
    var wd = size.width;
    var ht = size.height;
    var plotX = size.width * (x + 3) / 6;
    var plotY = size.height - size.height * ((y + 2) / 14);
    _drawFilledCircle(canvas, plotX,plotY,1.0);
    x = nextX;
    y = nextY;
  }

  CanvasPaint({totalNodes, context}){
    _totalNodes = totalNodes;
    _context = context;
  }

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    var paint1 = Paint()
      ..color = Color(0xff22ff22)
      ..strokeWidth = 3;
    var points = [Offset(50, 50),
      Offset(80, 70),
      Offset(-100, 175),
      Offset(-150, 175),
      Offset(150, 105),
      Offset(300, 75),
      Offset(320, 200),
      Offset(89, 125)];

    var points2 = <Offset>[];
    /*for (var i = 0; i < 200; i++) {
      points2.add(
          Offset(Random().nextInt(400) - 200, Random().nextInt(800) - 400));
    }*/

   /* var paint2 = Paint()
      ..color = Color(0xffffaa65)
      ..strokeWidth = 10;
    paint2.style = PaintingStyle.fill;
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points2, paint1);

    var treeList = getTree2();
    for (var i = 0; i < treeList.length; i++) {
      var ln = treeList[i];

      canvas.drawLine(Offset(ln.a1, ln.b1), Offset(ln.a2, ln.b2), paint2);
    }*/

    for (var i = 0; i < _totalNodes * 10; i++) {
      _drawTree(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}


class DoublePair<T1, T2, T3, T4> {
  final T1 a1;
  final T2 b1;
  final T3 a2;
  final T4 b2;

  DoublePair(this.a1, this.b1, this.a2, this.b2);
}