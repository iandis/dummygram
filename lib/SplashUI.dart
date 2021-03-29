import 'Singleton.dart';
import 'GlobalSettings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashUI extends StatefulWidget{
  @override
  _SplashUI createState() => _SplashUI();
}

class _SplashUI extends State<SplashUI>{
  @override
  void initState() {
    init() async {
      await My.auth.init();
      await Future.delayed(Duration(milliseconds: 2500));
      if (!GlobalSettings.me.authenticated) {
        await My.navigate.push(context, "login", popAllPage: true);
      } else {
        await My.navigate.push(context, "profile", popAllPage: true);
      }
    }
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
              "Dummygram",
              style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}