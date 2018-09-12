import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:math';
import 'package:screen/screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Traffic Light',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        backgroundColor: Color.fromARGB(255, 110, 110, 110),
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool changging = false;
  bool autoMode = false;
  int autoModeCounter = 3;
  var imgs = [
    'assets/images/red.png',
    'assets/images/go-green.png',
    'assets/images/green.png',
    'assets/images/go-red.png'
  ];
  double brightness = 0.2;

  String _imageSource = 'assets/images/red.png';
  Timer timerGlobal;

  void toggleAutoMode(context) {
    autoMode = !autoMode;
    changeLight();

    //   Scaffold.of(context).showSnackBar(new SnackBar(
    //    content: new Text(autoMode ? "Automode ON" : "Automode OFF"),
    // ));
    if (autoMode) {
      Screen.keepOn(true);
      // Set the brightness:
      Screen.setBrightness(0.9);
    } else {
      Screen.keepOn(false);
      // Set the brightness:
      Screen.setBrightness(0.5);
    }
  }

  void tick(Timer timer) {
    if (autoMode && !changging) {
      if (autoModeCounter <= 0) {
        print("------");
        changeLight();
        autoModeCounter = randDuration();
      } else {
        autoModeCounter--;
      }
      print("$autoModeCounter ${(DateTime.now()).toString()} ");
    }
  }

  int randDuration() {
    Random rnd = new Random();
    int sec = rnd.nextInt(10) + 5;
    print('rand $sec');
    return sec;
  }

  void changeLight() {
    setState(() {
      _counter++;
    });
    if (_counter >= this.imgs.length) {
      setState(() {
        _counter = 0;
      });
    }
    if (_counter == 1 || _counter == 3) {
      var timer = new Timer(new Duration(seconds: 1), (() {
        changeLight();
      }));
    }
    setState(() {
      _imageSource = imgs[_counter];
    });
    print("changing $_counter");
  }

  @override
  void initState() {
    super.initState();
    timerGlobal = Timer.periodic(new Duration(seconds: 1), tick);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

          child: new GestureDetector(
        onTap: () {
          if (_counter == 1 || _counter == 3) return;
          changeLight();
        },
        onLongPress: () {
          toggleAutoMode(context);
        },
        child: new Image.asset(
          _imageSource,
          fit: BoxFit.fitWidth,
        ),
      )),
    );
  }
}
