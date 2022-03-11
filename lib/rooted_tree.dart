import 'package:flutter/material.dart';
import './CanvasPaint.dart';

class LTree extends StatefulWidget {
  const LTree({Key? key, required this.totalNodes, required this.context}) : super(key: key);
  final int totalNodes;
  final BuildContext context;
  @override
  State<LTree> createState() => _LTreeState();
}

class _LTreeState extends State<LTree> {
  Widget _buildImage() {

    return new CustomPaint(
      size:Size(MediaQuery.maybeOf(context)!.size.width,MediaQuery.maybeOf(context)!.size.height - 100),
      painter: new CanvasPaint(totalNodes: widget.totalNodes, context: widget.context),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildImage(),
    );
  }
}
