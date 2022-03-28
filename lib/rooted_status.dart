import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootedStatus extends StatefulWidget {
  const RootedStatus({Key? key}) : super(key: key);

  @override
  State<RootedStatus> createState() => _RootedStatusState();
}

class _RootedStatusState extends State<RootedStatus> {
  bool _isRooted = false;
  String _humanSpree = "";
  String _goalText = "";
  late Timer _timer;

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  String formatHHMMSS(int seconds) {
    seconds = (seconds ~/ 1000);

    debugPrint("Seconds ${seconds}");
    if (seconds != null && seconds != 0) {
      int months = ((seconds % 31536000) / 2628000).truncate();
      int days = (((seconds % 31536000) % 2628000) / 86400).truncate();
      int hours = ((seconds % (3600 * 24)) / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String monthsStr = (months).toString().padLeft(1, '0');
      String daysStr = (days).toString().padLeft(1, '0');
      String hoursStr = (hours).toString().padLeft(1, '0');
      String minutesStr = (minutes).toString().padLeft(1, '0');
      String secondsStr = (seconds % 60).toString().padLeft(1, '0');

      if (hours == 0 && days == 0 && months == 0) {
        return "$minutesStr\m $secondsStr\s";
      } else if (days == 0 && months == 0) {
        return "$hoursStr\h $minutesStr\m $secondsStr\s";
      } else if (months == 0) {
        return "$daysStr\d $hoursStr\h $minutesStr\m";
      } else {
        return "$monthsStr\mo $daysStr\d $hoursStr\h";
      }
    } else {
      return "0m 0s";
    }
  }

  Future<void> _setRootedEphemeralState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? IS_ROOTED = await prefs.getBool('IS_ROOTED');


    String? GOAL_TEXT = await prefs.getString('SPREE_GOAL');

    setState(() {
      _isRooted = IS_ROOTED!;
      _goalText = GOAL_TEXT!;
    });
  }

  Future<void> _updateRootedTime() async {
    var prefs = await SharedPreferences.getInstance();
    int? SPREE_START_TIME = await prefs.getInt('SPREE_START_TIME');

    String spree =
        formatHHMMSS(DateTime.now().millisecondsSinceEpoch - SPREE_START_TIME!);

    setState(() {
      _humanSpree = spree;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isRooted) {
        timer.cancel();
      }
      _updateRootedTime();
    });
  }

  Future<void> _handleRootedState() async {
    await _setRootedEphemeralState();
    debugPrint("User is rooted? $_isRooted");
    if (_isRooted) {
      _updateRootedTime();
      _startTimer();
    }
  }

  Future<void> _setRootedSPState(bool rooted,String? goalText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('IS_ROOTED', rooted);
    await prefs.setInt(
        'SPREE_START_TIME', DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(("SPREE_GOAL"), goalText!);
  }

  Future<void> _handleCheckIn() async {
    await _setRootedSPState(false, "");
    _handleRootedState();
  }

  Future<void> _handleStart() async {
    TextEditingController My_controller1 = new TextEditingController();
    var alert = AlertDialog(
      title: Text("What is your goal?"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: 50,
          style: TextStyle(decoration: TextDecoration.none),
          maxLines: 1,

          autofocus: false,
          enabled: true,
          onSubmitted: (String text) {

            // Do something with your number like pass it to the next material page route
          },
          controller:My_controller1,
          decoration: new InputDecoration(
            errorStyle: TextStyle(color: Colors.redAccent),
            border: new UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(40, 40, 40, 1.0),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: new Icon(
              Icons.star,
              size: 18.0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('START'),
              onPressed: () {
                String text = My_controller1.text;
                debugPrint("My_controller1 $text");
                startTracking(text);
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ]),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  Future<void> startTracking(String goalText) async {
    await _setRootedSPState(true,goalText);
    _handleRootedState();
  }

  @override
  void initState() {
    /* check if user is currently rooted */
    _handleRootedState();
    super.initState();
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } on Exception catch (e) {
      debugPrint("E $e");
    }
    super.dispose();
  }

  Widget _ActiveCard() => Card(
        color: Colors.blueAccent.shade400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 14),
            ListTile(
              leading: Icon(Icons.cake,
                  size: 90.0, color: Theme.of(context).colorScheme.primary),
              title: Text(
                '$_humanSpree',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text('Woo! You\'re on a streak!'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('CHECK-IN'),
                  onPressed: () {
                    _handleCheckIn();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      );

  Widget _InactiveCard() => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 14),
            ListTile(
              leading:
                  Icon(Icons.warning_amber, size: 90.0, color: Colors.grey),
              title: Text(
                'Get on track!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.deepOrange,
                ),
              ),
              subtitle: Text('Now is a great time to start :)'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('START'),
                  onPressed: () {
                    _handleStart();
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('VIEW LOG'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children:[ Text("$_goalText"),_isRooted ? _ActiveCard() : _InactiveCard(),]
      ),
    );
  }
}
