// screen_a.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './rooted_status.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  String _humanSpree = "";
  late Timer _timer;
  int _start = 10;

  /*void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) async => {

        var prefs = await SharedPreferences.getInstance();
    int? SPREE_START_TIME = await prefs.getInt('SPREE_START_TIME');
    Duration SpreeDuration = Duration(milliseconds: DateTime
        .now()
        .millisecondsSinceEpoch - SPREE_START_TIME!);
    String spree = format(SpreeDuration);

    setState(() {
      _humanSpree = spree;
    });
  });


  }*/

  Future<void> _updateTimer() async {
    debugPrint("Updating!!!");
    var prefs = await SharedPreferences.getInstance();
    int? SPREE_START_TIME = await prefs.getInt('SPREE_START_TIME');
    Duration SpreeDuration = Duration(milliseconds: DateTime
        .now()
        .millisecondsSinceEpoch - SPREE_START_TIME!);
    String spree = format(SpreeDuration);

    setState(() {
      _humanSpree = spree;
    });
  }

  @override
  void initState(){
    debugPrint("Init state");
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      debugPrint("timer tick");
      _updateTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _setSpree() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('SPREE_ON', true);
    await prefs.setInt(
        'SPREE_START_TIME', DateTime.now().millisecondsSinceEpoch);
  }
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  void _getSpreeState() async {
    final prefs = await SharedPreferences.getInstance();
    int? SPREE_START_TIME = await prefs.getInt('SPREE_START_TIME');
    Duration SpreeDuration = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - SPREE_START_TIME!);
    String spree = format(SpreeDuration);
    debugPrint("Spree started ${SPREE_START_TIME} - ${spree} - ${SpreeDuration}");
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
          RootedStatus(),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.warning_amber),
                  title: Text(
                    'Spree not active',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text('SPREE $_humanSpree' ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('START'),
                      onPressed: () {
                        _setSpree();
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('VIEW LOG'),
                      onPressed: () {_getSpreeState();},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
