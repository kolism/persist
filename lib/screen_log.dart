// screen_a.dart
import 'package:flutter/material.dart';

class ScreenLog extends StatelessWidget {
  const ScreenLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        mainAxisSize: MainAxisSize.max,
       children: [

         Text("Log 1"),
         Divider(),
         Text("Log 1"),
         Divider(),
         Text("Log 1"),
         Divider(),
         Text("Log 1"),
         Divider(),
         Text("Log 1"),
       ],
      ),
    );
  }
}