import 'package:flutter/material.dart';

enum ScreenItem { home, awards, log }

const Map<ScreenItem, String> screenName = {
  ScreenItem.home: 'home',
  ScreenItem.awards: 'awards',
  ScreenItem.log: 'Log',
};

const Map<ScreenItem, String> screenRoute= {
  ScreenItem.home: '/home',
  ScreenItem.awards: '/awards',
  ScreenItem.log: '/log',
};

const Map<ScreenItem, MaterialColor> activeTabColor = {
  ScreenItem.home: Colors.deepOrange,
  ScreenItem.awards: Colors.green,
  ScreenItem.log: Colors.blue,
};