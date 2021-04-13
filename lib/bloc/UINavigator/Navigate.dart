import 'dart:typed_data';

import 'package:dummygram/ui/ProfileUI.dart';

import 'INavigate.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigate implements INavigate {

  Map<String, Widget> pages = Map();
  @override
  void register(String name, page){
    pages[name] = page;
  }
  @override
  Future<void> push(context, String ui, {bool popCurrentPage = false, bool popAllPage = false, arg}) async {
    context = context as BuildContext;
    Widget destUI() {
      try{
        return pages[ui];
      }catch(ex){
        return null;
      }
    }

    if (popAllPage)
      // SchedulerBinding.instance.addPostFrameCallback((_) async =>
        await Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => destUI() ),
            (route) => false,
        );
      //);
    else if (popCurrentPage) {
      // SchedulerBinding.instance.addPostFrameCallback((_) async =>
        await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => destUI() )
        );
      // );
      Navigator.pop(context);
    }
    else
      // SchedulerBinding.instance.addPostFrameCallback((_) async =>
        await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => destUI() )
        );
      // );
  }
}