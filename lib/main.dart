import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import './screen_home.dart';
import './screen_awards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        /*theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          bottomAppBarColor: Colors.deepOrange),*/
        theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.hippieBlue),
        themeMode: ThemeMode.dark,
        home: WelcomePage());
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    _getWelcomeState();
    super.initState();
  }

  void _setWelcomeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('WELCOME_PASS', true);
  }

  void _getWelcomeState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? WELCOME_PASS = await prefs.getBool('WELCOME_PASS');
    if (WELCOME_PASS == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'Dashboard',
          ),
        ),
      );
    }
  }

  Widget _buildBottomNavigation(context) => Align(
        alignment: FractionalOffset.bottomCenter,
        //this is very important, without it the whole screen will be blurred
        child: ClipRect(
          //I'm using BackdropFilter for the blurring effect
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    autofocus: true,
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      onSurface: Colors.orangeAccent,
                      side: BorderSide(color: Colors.deepOrange, width: 1),
                      elevation: 20,
                      minimumSize: Size(100, 50),
                      shadowColor: Colors.deepOrange,
                    ),
                    onPressed: () {
                      debugPrint('Received click');
                      _setWelcomeState();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(
                            title: 'Dashboard',
                          ),
                        ),
                      );
                    },
                    child: const Text('Enter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                "Persist",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    color: Colors.red),
              ),
            ),
            _buildBottomNavigation(context)
          ],
        ),
      ),
    );
  }
}


Route _createRoute(int index) {

  final List _screens = [
    {"screen": const ScreenHome(), "title": "Screen A Title"},
    {"screen": const ScreenAwards(), "title": "Screen B Title"}
  ];

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _screens[index]["screen"],
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const ScreenHome(), "title": "Screen A Title"},
    {"screen": const ScreenAwards(), "title": "Screen B Title"}
  ];

  void _selectScreen(int index) {
    Navigator.of(context).push(_createRoute(index));
    setState(() {
      _selectedScreenIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: ScreenHome(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap:_selectScreen,
        items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Awards'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Log'),
      ],
      ),
    );
  }
}
