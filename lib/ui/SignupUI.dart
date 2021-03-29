
import 'package:dummygram/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Singleton.dart';

class SignupUI extends StatefulWidget{
  @override
  _SignupUI createState() => _SignupUI();
}

class _SignupUI extends State<SignupUI>{
  UserInf user = new UserInf();
  String pass, cpass, errText0, errText1, errText2;
  checkEmail() =>
    setState(() {
      errText0 = !My.validators.isValidEmail(user.email) ? "Email is not valid" : null;
    });
  checkPass(int which) =>
    setState(() {
      switch(which){
        case 1: /* pass */
          if(My.validators.isValidPassword(pass) == -1)
            errText1 = "cannot be empty.";
          else if(My.validators.isValidPassword(pass) == 0)
            errText1 = "must be at least 8 characters";
          else
            errText1 = null;
          break;
        case 2: /* confirm pass */
          if(My.validators.isValidPassword(cpass) == -1)
            errText2 = "cannot be empty.";
          else if(My.validators.isValidPassword(cpass) == 0)
            errText2 = "must be at least 8 characters";
          else if (cpass != pass)
            errText2 = "password mismatch.";
          else
            errText2 = null;
          break;
      }
    });

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
                padding: EdgeInsets.only(left:10, right:10, bottom: 20),
                child: TextField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    errorText: errText0,
                    counterText: "",
                  ),
                  onChanged: (String value){
                    setState(() {
                      user.email=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    checkEmail();
                    node.nextFocus();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                padding: EdgeInsets.only(left:10,right:10,bottom:20),
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
                  textInputAction: TextInputAction.done,
                  onEditingComplete: (){
                    checkPass(2);
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left:10,right:10),
                  child: ElevatedButton(
                    child: Text("Sign me up"),
                    onPressed: My.validators.isValidEmail(user.email) &&
                        My.validators.isValidPassword(pass) == 1 &&
                        cpass == pass ? ()
                    async {
                      user.name = user.email.split('@')[0];
                      user.bio = "";
                      user.gender = -1;
                      user.imgUrl = "";
                      user.flwr = 0;
                      user.flwg = 0;
                      String res = await My.auth.regUser(user, pass);
                      if(res==null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "You have signed up successfully.",
                            style: TextStyle(color: Colors.white),),
                          backgroundColor: Theme
                              .of(context)
                              .accentColor,
                          duration: Duration(milliseconds: 3000),
                        ));
                        My.auth.setCurrentUser(user);
                        await My.navigate.push(
                            context, "profile", popAllPage: true);
                      }
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Sign up failed. "+res,
                              style: TextStyle(color: Colors.white),),
                            backgroundColor: Theme
                                .of(context)
                                .errorColor,
                            duration: Duration(milliseconds: 3000)));
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