import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persist/graphist/graphist.dart';

class CircleAnim extends Graphist {
  int _totalNodes = 0;
  CircleAnim(totalNodes) {
    _totalNodes = totalNodes;
  }
  @override
  void u(double t) {
    c.drawCircle(
      Offset(x.width / 2, x.height / 2),
      S(t).abs() * x.height / 20 + min(log(_totalNodes), 500),
      Paint()..color = R(10 + T(t) / 20, 42, C(t) * 255, 0.5),
    );
  }
}
