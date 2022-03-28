import 'package:flutter/material.dart';
import 'graphist/graphist.dart';
import './rooted_tree_viewer.dart';


class LTree extends StatefulWidget  {
  const LTree({Key? key, required this.totalNodes, required this.context}) : super(key: key);
  final int totalNodes;
  final BuildContext context;
  @override
  State<LTree> createState() => _LTreeState();
}

class _LTreeState extends State<LTree> {
  Widget _buildImage() {

    return RootedTreeViewer(
      graphistElem: ExampleTree(),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildImage(),
    );
  }
}


class ExampleTree extends Graphist {
  @override
  void u(double t) {
    c.drawCircle(
      Offset(x.width / 2, x.height / 2),
      S(t).abs() * x.height / 4 + 42,
      Paint()..color = R(C(t) * 255, 42, 60 + T(t)),
    );
  }
}

