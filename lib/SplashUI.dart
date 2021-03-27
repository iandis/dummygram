import 'bloc/Auth/Auth.dart';
import 'GlobalSettings.dart';

import 'package:dummygram/bloc/UINavigator/Navigate.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SplashUI extends StatefulWidget{
  @override
  _SplashUI createState() => _SplashUI();
}

class _SplashUI extends State<SplashUI>{
  @override
  void initState() async {
    await Auth.instance().init();
    if(!GlobalSettings.instance().authenticated()){
      await Navigate.instance().push(context, UI.LOGIN, popAllPage: true);
    }else{
      await Navigate.instance().push(context, UI.PROFILE, popAllPage: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: [
            Text(
            "Dummygram",
            style: Theme.of(context).textTheme.headline1,
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