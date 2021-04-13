import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Singleton.dart';

class ProfileUI extends StatefulWidget{
  final Uint8List avatar = My.i.globalSettings.userInfo.avatar128;

  @override
  _ProfileUI createState()=>_ProfileUI();

}

class _ProfileUI extends State<ProfileUI>{
  StreamSubscription<User> userSub;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    userSub = FirebaseAuth.instance.authStateChanges().listen((event) async =>
      event ?? await userSignOut()
    );
    super.initState();
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  userSignOut() async {
    My.i.globalSettings.userInfo.clear();
    await userSub.cancel();
    await My.i.cachedImage.invalidateCache(0);
    await My.i.navigate.push(
            context, "login", popAllPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width/8),
                        padding: EdgeInsets.only(top:50),
                        child: TextButton(
                          child: Icon(Icons.edit_outlined, size: 20, color: Colors.white,),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () async => await My.i.navigate.push(context, "editprofile"),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width/8),
                        padding: EdgeInsets.only(top:50),
                        child: TextButton(
                          child: Icon(Icons.logout, size: 20, color: Colors.white),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            /*await My.i.auth.signOut()
                                .then((_) async => await My.i.navigate.push(context, "login", popAllPage: true));*/
                          },
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.cyanAccent,
                          child: CircleAvatar(
                              radius: 60,
                              backgroundImage: widget.avatar == null ?
                                                  AssetImage("assets/images/default_avatar.png") :
                                                  MemoryImage(widget.avatar)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12.0),
                    child: Text(
                      My.i.globalSettings.userInfo.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:3.0),
                    child: Text(
                      "@"+My.i.globalSettings.userInfo.username,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:20, right:20,top:30.0, bottom: 30),
                    child: Text(
                      My.i.globalSettings.userInfo.bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white12,
                  ),
                  IntrinsicHeight(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Expanded(
                          flex:1,
                          child: Container(
                              padding: EdgeInsets.only(top:6,bottom: 9,),
                              child:Column(
                                children: [
                                  Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Posts",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Colors.white12,
                        ),
                        Expanded(
                          flex:1,
                          child: Container(
                              padding: EdgeInsets.only(top:6,bottom: 9,),
                              child:Column(
                                children: [
                                  Text(
                                    My.i.globalSettings.userInfo.flwr.length.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Followers",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Colors.white12,
                        ),
                        Expanded(
                          flex:1,
                          child: Container(
                              padding: EdgeInsets.only(top:6,bottom: 9,),
                              child:Column(
                                children: [
                                  Text(
                                    My.i.globalSettings.userInfo.flwg.length.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Following",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white12,
                  ),
                ],
              ),
            ),
          ),
        );
  }
}