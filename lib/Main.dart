import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'Singleton.dart';
import 'ui/_all.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

registerPages() async {
  My.i.navigate.register("login", LoginUI());
  My.i.navigate.register("profile", ProfileUI());
  My.i.navigate.register("signup", SignupUI());
  My.i.navigate.register("editprofile", EditProfileUI());
}

Future<Widget> init() async {
  await My.i.auth.init();
  int tryGetUser = await My.i.auth.getCurrentUser();

  if (tryGetUser == 0 || tryGetUser == -1)
    return LoginUI();
  else {
    //var avatar = await My.i.auth.initUserAvatar();
    return ProfileUI();
  }
}

Future<void> requestPermissions() async{
  var storagePerm = await Permission.storage.request();
  if(!storagePerm.isGranted) {
    exit(0);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await requestPermissions(); ///requesting permissions first is mandatory
  await registerPages(); ///registering pages for page routing
  await My.i.cachedImage.init(); ///init cachedImage is necessary, otherwise any cachedImage functions won't work.
  var firstPage = await init();
  runApp(Main(firstPage: firstPage));
}

// class Main extends StatefulWidget{
//   final Widget firstPage;
//   const Main({Key key, this.firstPage}) : super(key: key);
//   @override
//   _Main createState() => _Main();
// }

class Main extends StatelessWidget{
  //static final Main i = Main();
  final Widget firstPage;
  const Main({Key key, this.firstPage}) : super(key: key);

  @override
  Widget build(BuildContext context){
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
              onPrimary: Colors.white,
              primary: Color(0xff40C4FF),
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
      home: firstPage,
    );
  }
}

/*class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp({Key key, this.firstPage}) : super(key: key);
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
            onPrimary: Colors.white,
            primary: Color(0xff40C4FF),
          )
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w700, color: Colors.grey[50]),
          headline2: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w400, color: Colors.grey[50]),
          headline3: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.w700, color: Colors.grey[50]),
          headline4: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.w400, color: Colors.grey[50]),
          headline5: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey[50]), *//* Bold *//*
          headline6: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[50]), *//* Regular *//*
        ),
      ),
      home: firstPage,
    );
  }
}*/

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
