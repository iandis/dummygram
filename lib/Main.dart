import 'SplashUI.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dummygram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff191e3b),
        brightness: Brightness.dark,
        accentColor: Color(0xff40C4FF),
        errorColor: Color(0xffD50000),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Color(0xff40C4FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Color(0xff40C4FF),
            primary: Color(0xff40C4FF).withOpacity(0.5),
            textStyle: TextStyle(color: Colors.white),
          )
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w700, color: Colors.grey[50]),
          headline2: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w400, color: Colors.grey[50]),
          headline3: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.w700, color: Colors.grey[50]),
          headline4: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.w400, color: Colors.grey[50]),
          headline5: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[50]), /* Bold */
          headline6: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[50]), /* Regular */

        ),
      ),
      home: SplashUI(),
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
*/
