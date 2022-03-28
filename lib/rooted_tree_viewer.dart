import 'package:flutter/material.dart';
import 'graphist/graphist.dart';


class RootedTreeViewer extends StatefulWidget {
  /// Constructs [RootedTreeViewer].
  const RootedTreeViewer({
    Key? key,
    required this.graphistElem,
  }) : super(key: key);


  final Graphist graphistElem;

  @override
  _RootedTreeViewerState createState() => _RootedTreeViewerState();
}

class _RootedTreeViewerState extends State<RootedTreeViewer> {


  @override
  void didUpdateWidget(covariant RootedTreeViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
            ),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GraphistContainer(
                  graphist: widget.graphistElem,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}