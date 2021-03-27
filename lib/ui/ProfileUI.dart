import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dummygram/models/User.dart';

import '../GlobalSettings.dart';

class ProfileUI extends StatefulWidget{
  final UserInf user = GlobalSettings.instance().userInfo;
  @override
  _ProfileUI createState()=>_ProfileUI();
}

class _ProfileUI extends State<ProfileUI>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
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
                          child: Icon(Icons.edit_outlined,size: 20),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: (){},
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width/8),
                        padding: EdgeInsets.only(top:50),
                        child: TextButton(
                          child: Icon(Icons.add_a_photo_outlined, size: 20),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: (){},
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          radius:70,
                          backgroundColor: widget.user.gender == 0 ? Colors.cyanAccent : Colors.pink[200],
                          child: CircleAvatar(
                            radius: 69,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 58,
                              //TODO: Load image from imgUrl
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12.0),
                    child: Text(
                      widget.user.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:20, right:20,top:30.0, bottom: 30),
                    child: Text(
                      widget.user.bio,
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
                                    widget.user.flwr.toString(),
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
                                    widget.user.flwg.toString(),
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