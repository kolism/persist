
import 'package:flutter/material.dart';

class RootedStatus extends StatefulWidget {
  const RootedStatus({Key? key}) : super(key: key);

  @override
  State<RootedStatus> createState() => _RootedStatusState();
}

class _RootedStatusState extends State<RootedStatus> {
  bool _isRooted = false;

  @override
  void initState(){
    /* check if user is currently rooted */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:Text("STATUS"));
  }
}
