import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'painter.dart';

class GraphistContainer extends StatefulWidget {
  const GraphistContainer({
    Key? key,
    this.paused = false,
    required this.graphist,
  }) : super(key: key);

  final Graphist graphist;
  final bool paused;

  @override
  _GraphistContainerState createState() => _GraphistContainerState();


}

class _GraphistContainerState extends State<GraphistContainer>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _time;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _time = ValueNotifier(0);
    _ticker = createTicker(_update);

    if (!widget.paused) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant GraphistContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.graphist != widget.graphist) {
      _time.value = 0;
      _ticker
        ..stop()
        ..start();
    }

    if (!widget.paused && oldWidget.paused && !_ticker.isActive) {
      _ticker
        ..muted = false
        ..start();
    } else {
      _ticker.muted = widget.paused;
    }
  }

  @override
  void dispose() {
    _time.dispose();
    _ticker.dispose();

    super.dispose();
  }

  void _update(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: _ticker.isActive,
      painter: GraphistPainter(
        time: _time,
        delegate: widget.graphist,
      ),
    );
  }
}