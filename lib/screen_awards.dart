// screen_a.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './rooted_tree.dart';

class ScreenAwards extends StatefulWidget {
  const ScreenAwards({Key? key}) : super(key: key);

  @override
  State<ScreenAwards> createState() => _ScreenAwardsState();
}

class _ScreenAwardsState extends State<ScreenAwards> {
  int _totalMinutesElapsed = 0;
  bool _isRooted = false;
  int _totalNodes = 0;

  Future<void> _setRootedTimeEphemeralState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? IS_ROOTED = await prefs.getBool('IS_ROOTED');
    setState(() {
      _isRooted = IS_ROOTED!;
    });
  }

  int _getMinutes(int seconds) {
    seconds = (seconds ~/ 1000);

    if (seconds != null && seconds != 0) {
      int minutes = (seconds / 60).truncate();
      return minutes;
    }
    return 10;
  }


  Future<void> _updateRootedTime() async {

    var prefs = await SharedPreferences.getInstance();
    int? SPREE_START_TIME = await prefs.getInt('SPREE_START_TIME');

    int minutes = _getMinutes(DateTime
        .now()
        .millisecondsSinceEpoch - SPREE_START_TIME!);

    setState(() {
      _totalNodes = minutes;
      _totalMinutesElapsed = minutes;
    });
  }

  Future<void> _initApp() async {
    await _setRootedTimeEphemeralState();
    if(_isRooted) {
      _updateRootedTime();
    }
  }

  @override
  void initState(){
    _initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          LTree(totalNodes: _totalNodes, context: context),

          Text("Current Growth: $_totalNodes"),
         ]
      ),
    );
  }
}