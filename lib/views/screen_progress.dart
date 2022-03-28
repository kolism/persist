// screen_a.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'progress/rooted_tree.dart';

class ScreenAwards extends StatefulWidget {
  const ScreenAwards({Key? key}) : super(key: key);

  @override
  State<ScreenAwards> createState() => _ScreenAwardsState();
}

class _ScreenAwardsState extends State<ScreenAwards> {
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
    return LTree(totalNodes: _totalNodes, context: context);
  }
}