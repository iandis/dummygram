import 'package:flutter/material.dart';
import 'IPopup.dart';

class Popup implements IPopup{
  bool _isBusy = false;
  @override
  void error(context, String message, {int duration = 3000}) async {
    if(_isBusy) return;
    _isBusy = true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),),
        backgroundColor: Theme
            .of(context)
            .errorColor,
        duration: Duration(milliseconds: duration)));
    await Future.delayed(
        Duration(milliseconds: duration))
        .whenComplete(() => _isBusy = false);
  }

  @override
  void inform(context, String message, {int duration = 3000}) async {
    if(_isBusy) return;
    _isBusy = true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),),
      backgroundColor: Theme
          .of(context)
          .accentColor,
      duration: Duration(milliseconds: duration),
    ));
    await Future.delayed(
        Duration(milliseconds: duration))
        .whenComplete(() => _isBusy = false);
  }

  @override
  void warning(context, String message, {int duration = 3000}) async {
    if(_isBusy) return;
    _isBusy = true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Color(0xFF111111)),),
      backgroundColor: Colors.amber,
      duration: Duration(milliseconds: duration),
    ));
    await Future.delayed(
        Duration(milliseconds: duration))
        .whenComplete(() => _isBusy = false);
  }

  @override
  void custom(
      context,
      String message,
      textColor,
      backgroundColor,
      {int duration = 3000}) async {
    if(_isBusy) return;
    _isBusy = true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),),
      backgroundColor: backgroundColor,
      duration: Duration(milliseconds: duration),
    ));
    await Future.delayed(
        Duration(milliseconds: duration))
        .whenComplete(() => _isBusy = false);
  }
}