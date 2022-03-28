import 'package:flutter/material.dart';
import '../../graphist/graphist.dart';
import 'circle_animation.dart';
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
      graphistElem: CircleAnim(widget.totalNodes),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildImage(),
    );
  }
}

