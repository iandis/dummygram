import 'INavigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dummygram/ui/_all.dart';

class Navigate implements INavigate{
  Navigate();
  @override
  Future<void> push(context, String ui, {bool popCurrentPage = false, bool popAllPage = false}) async {
    context = context as BuildContext;
    Widget destUI() {
      switch (ui) {
        case "signup":
          return SignupUI();
        case "login":
          return LoginUI();
        case "profile":
          return ProfileUI();
        default:
          return null;
      }
    }

    if (popAllPage)
      await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) {
        return destUI();
      }), (Route<dynamic> route) => false);
    else if (popCurrentPage) {
      await Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return destUI();
      }));
      Navigator.pop(context);
    }
    else
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return destUI();
      }));

  }
}