import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import './screen_home.dart';
import './screen_awards.dart';
import './screen_log.dart';

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
      theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.material),
      themeMode: ThemeMode.dark,
      home: WelcomePage(),
    );
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
                    color: Colors.deepOrange),
              ),
            ),
            _buildBottomNavigation(context)
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> _pages = <Widget>[
    ScreenHome(),
    ScreenAwards(),
    ScreenLog()
  ];

  int _selectedScreenIndex = 0;
  void _selectTab(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child),
        child: _pages[_selectedScreenIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedScreenIndex,
        onTap: _selectTab,
        color: Colors.black38,
        backgroundColor: Theme.of(context).colorScheme.background,
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        items: [
          Icon(Icons.home, size: 30.0, color: Colors.white),
          Icon(Icons.star, size: 30.0, color: Colors.white),
          Icon(Icons.list, size: 30.0, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.easeOutCubic,
        height: 60.0,
      ),
    );
  }
}
