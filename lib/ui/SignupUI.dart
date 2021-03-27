import 'package:dummygram/bloc/UINavigator/Navigate.dart';
import 'package:dummygram/models/User.dart';
import 'package:dummygram/bloc/Auth/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'ProfileUI.dart';
import 'package:dummygram/bloc/Validators/Validators.dart';

class SignupUI extends StatefulWidget{
  @override
  _SignupUI createState() => _SignupUI();
}

class _SignupUI extends State<SignupUI>{
  UserInf user = new UserInf();
  String pass, cpass, errText0, errText1, errText2;
  void checkEmail(){
    errText0 = !Validators.instance().isValidEmail(user.email) ? "Email is not valid" : null;
  }
  void checkPass(int which){
    switch(which){
      case 1: /* pass */
        if(Validators.instance().isValidPassword(pass) == -1)
          errText1 = "cannot be empty.";
        else if(Validators.instance().isValidPassword(pass) == 0)
          errText1 = "must be at least 8 characters";
        else
          errText1 = null;
        break;
      case 2: /* confirm pass */
        if(Validators.instance().isValidPassword(cpass) == -1)
          errText2 = "cannot be empty.";
        else if(Validators.instance().isValidPassword(cpass) == 0)
          errText2 = "must be at least 8 characters";
        else if (cpass != pass)
          errText2 = "password mismatch.";
        else
          errText2 = null;
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Sign up",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:10,right:10),
                child: TextField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    errorText: errText0,
                  ),
                  onChanged: (String value){
                    setState(() {
                      user.email=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    checkEmail();
                    node.nextFocus();},
                ),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                      activeColor: Colors.cyanAccent,
                      groupValue: gender,
                      value:0,
                      onChanged: (int value){
                        setState(() {
                          gender=value;
                          user.gender=value;
                        });
                      }
                  ),
                  Text("Male"),
                  Radio(
                      activeColor: Colors.cyanAccent,
                      groupValue: gender,
                      value:1,
                      onChanged: (int value){
                        setState(() {
                          gender=value;
                          user.gender=value;
                        });
                      }
                  ),
                  Text("Female"),
                ],
              ),*/
              Padding(
                padding: EdgeInsets.only(left:10,right:10,bottom:10),
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    errorText: errText1,
                  ),
                  onChanged: (String value){
                    setState(() {
                      pass = value;
                    });
                  },
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    checkPass(1);
                    node.nextFocus();
                    },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:10,right:10,bottom:10),
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm password",
                    errorText: errText2,
                  ),

                  onChanged: (String value){
                    setState(() {
                      cpass = value;
                    });
                  },

                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    checkPass(2);
                    node.nextFocus();
                    },
                ),
              ),
              /*Padding(
                padding: EdgeInsets.only(left:10,right: 10,bottom:10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 150,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bio",
                  ),
                  onChanged: (String value){
                    setState(() {
                      user.bio=value;
                    });
                  },
                  *//*textInputAction: TextInputAction.next,*//*
                  *//*onEditingComplete: () => node.nextFocus(),*//*
                ),
              ),*/
              Padding(
                  padding: EdgeInsets.only(left:10,right:10),
                  child: TextButton(
                    child: Text("Sign up now"),
                    onPressed: Validators.instance().isValidEmail(user.email) &&
                        Validators.instance().isValidPassword(pass) == 1 &&
                        cpass == pass ? ()
                    async {
                      user.name = user.email.split('@')[0];
                      user.bio = "";
                      user.gender = -1;
                      user.imgUrl = "";
                      user.flwr = 0;
                      user.flwg = 0;
                      bool res = await Auth.instance().regUser(user, pass);
                      if(res) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("You have signed up successfully."),
                          backgroundColor: Theme
                              .of(context)
                              .accentColor,
                          duration: Duration(milliseconds: 1500),
                        ));
                        await Navigate.instance().push(
                            context, UI.PROFILE, popAllPage: true);
                      }
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Sign up failed. Try again or check your connection."),
                            backgroundColor: Theme
                                .of(context)
                                .errorColor,
                            duration: Duration(milliseconds: 1500)));
                    } : null,
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}