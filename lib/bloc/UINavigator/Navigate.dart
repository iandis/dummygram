import 'INavigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:dummygram/ui/_all.dart';
enum UI{
  SIGNUP,
  LOGIN,
  PROFILE,
}
class Navigate implements INavigate{
  static Navigate instance() => new Navigate();
  @override
  Future<void> push(context, ui, {bool popCurrentPage = false, bool popAllPage = false}) async {
    Widget destUI() {
      switch (ui) {
        case UI.SIGNUP:
          return new SignupUI();
        case UI.LOGIN:
          return new LoginUI();
        case UI.PROFILE:
          return new ProfileUI();
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