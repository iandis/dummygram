import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../Singleton.dart';
class LoginUI extends StatefulWidget{
  @override
  _LoginUI createState()=>_LoginUI();

}
class _LoginUI extends State<LoginUI>{
  String email, pass, errText0, errText1;
  checkEmail()=>
    setState(() {
      errText0 = !My.validators.isValidEmail(email) ? "Email is not valid" : null;
    });
  checkPass()=>
    setState(() {
      if(My.validators.isValidPassword(pass) == -1)
        errText1 = "cannot be empty.";
      else if(My.validators.isValidPassword(pass) == 0)
        errText1 = "must be at least 8 characters";
      else
        errText1 = null;
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
                  "Welcome",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:10, right:10, bottom: 10),
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
                      email=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    checkEmail();
                    node.nextFocus();},
                ),
              ),
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
                    checkPass();
                    node.nextFocus();
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left:10, right:10, bottom: 10),
                  child: ElevatedButton(
                    child: Text("Log me in"),
                    onPressed: My.validators.isValidEmail(email) &&
                        My.validators.isValidPassword(pass) == 1 ? ()
                    async {
                      var result = await My.auth.loginUser(email, pass);
                      String res = result[0];
                      if(res == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Welcome back !",
                            style: TextStyle(color: Colors.white),),
                          backgroundColor: Theme
                              .of(context)
                              .accentColor,
                          duration: Duration(milliseconds: 3000),
                        ));
                        My.auth.setCurrentUser(result[1]);
                        await My.navigate.push(
                            context, "profile", popAllPage: true);
                      }
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Login failed. Incorrect email or password "+res,
                                style: TextStyle(color: Colors.white),),
                            backgroundColor: Theme
                                .of(context)
                                .errorColor,
                            duration: Duration(milliseconds: 3000)));
                    } : null,
                  )
              ),
              Padding(
                padding: EdgeInsets.only(left:10,right:10),
                child: Text(
                    "or",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:10,right:10),
                child: TextButton(
                  child: Text(
                    "Sign up",
                    style: TextStyle(decoration: TextDecoration.underline)),
                  onPressed: () async {
                    await My.navigate.push(context, "signup");
                  },
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}