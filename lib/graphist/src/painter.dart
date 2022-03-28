import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
abstract class Graphist {

  Canvas get c => _c;
  late Canvas _c;


  GraphistContext get x => _x;
  late GraphistContext _x;

  @visibleForTesting
  set x(GraphistContext context) {
    assert(() {
      _x = context;
      return true;
    }());
  }


  Size get s => x.size;

  void u(double t);

  double S(double radians) => sin(radians);

  double C(double radians) => cos(radians);

  double T(double radians) => tan(radians);


  Color R(num r, num g, num b, [num? o]) {
    return Color.fromRGBO(r ~/ 1, g ~/ 1, b ~/ 1, (o ?? 1).toDouble());
  }


  Size s2q(
      double dimension, {
        bool translate = true,
        bool clip = true,
      }) {
    final shortestSide = min(x.width, x.height);
    if (translate) {
      // Center the square.
      c.translate((x.width - shortestSide) / 2, (x.height - shortestSide) / 2);
    }

    final scaling = shortestSide / dimension;
    c.scale(scaling);
    final scaledSize = translate
        ? Size.square(dimension)
        : Size(x.width / scaling, x.height / scaling);

    if (clip) {
      c.clipRect(Offset.zero & scaledSize);
    }

    return scaledSize;
  }
}


@immutable
class GraphistContext {

  const GraphistContext(this.size);


  final Size size;


  double get width => size.width;


  double get height => size.height;

  @override
  String toString() {
    return 'GraphistContext($width, $height)';
  }
}


class GraphistPainter extends CustomPainter {

  const GraphistPainter({
    required this.time,
    required this.delegate,
  }) : super(repaint: time);


  final ValueListenable<double> time;

  final Graphist delegate;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    delegate._c = canvas;
    delegate._x = GraphistContext(size);
    delegate.u(time.value);

    canvas.restore();
  }

  @override
  bool shouldRepaint(GraphistPainter oldDelegate) {
    return oldDelegate.delegate != delegate;
  }
}