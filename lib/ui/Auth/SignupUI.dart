
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Singleton.dart';

class SignupUI extends StatefulWidget{
  @override
  _SignupUI createState() => _SignupUI();
}

class _SignupUI extends State<SignupUI>{
  String /*name,*/
      username,
      email,
      pass,
      cpass,

      errEmail,
      errPass,
      errCPass,
      errUname;
  bool passObscure = true,
      cpassObscure = true;

  IconData passEye = Icons.visibility_off_outlined;
  IconData cpassEye = Icons.visibility_off_outlined;
  Widget signUpButton = Text("Sign me up");

  /*final FocusNode textNodes0 = FocusNode();*/
  final FocusNode textNodes1 = FocusNode();
  final FocusNode textNodes2 = FocusNode();
  final FocusNode textNodes3 = FocusNode();
  final FocusNode textNodes4 = FocusNode();

  /*checkName() =>
    setState(() {
      errName = !My.i.validators.isNullOrWhitespace(name) ? "cannot be blank." : null;
    });*/
  checkUsername()=>
    setState((){
      if(My.i.validators.isNullOrWhitespace(username)) {
        errUname = "cannot be blank.";
      }else if(username.length<3){
        errUname = "must be at least 3 characters.";
      }else if(!My.i.validators.isValidUsername(username)){
        errUname = "only a-z, 0-9, and \"_\" are allowed.";
      }else
        errUname = null;
    });
  checkEmail() =>
    setState(() {
      errEmail = My.i.validators.isNullOrWhitespace(email) ?
      "cannot be blank." :
      (!My.i.validators.isValidEmail(email) ? "email is not valid" : null);
    });
  checkPass(int which) =>
    setState(() {
      switch(which){
        case 1: /* pass */
          if(My.i.validators.isValidPassword(pass) == -1)
            errPass = "cannot be blank.";
          else if(My.i.validators.isValidPassword(pass) == 0)
            errPass = "must be at least 8 characters";
          else
            errPass = null;
          break;
        case 2: /* confirm pass */
          if(My.i.validators.isValidPassword(cpass) == -1)
            errCPass = "cannot be blank.";
          else if (cpass != pass)
            errCPass = "password mismatch.";
          else if(My.i.validators.isValidPassword(cpass) == 0)
            errCPass = "must be at least 8 characters";
          else
            errCPass = null;
          break;
      }
    });
  setObscurePass(int which)=>
      setState((){
        switch(which){
          case 1: /* pass */
            passObscure = !passObscure;
            passEye = passObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined;
            break;
          case 2: /* cpass */
            cpassObscure = !cpassObscure;
            cpassEye = cpassObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined;
            break;
        }
      });
  setSignupButtonLoading(bool loading) =>
      setState((){
        if(loading)
          signUpButton = SizedBox(
              height: 15,
              width: 15,
              child:
                CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                )
          );
        else
          signUpButton = Text("Sign me up");
      });
  clearErrText(int which) =>
      setState((){
        switch(which){
          case 1:
            errUname = null;
            break;
          case 2:
            errEmail = null;
            break;
          case 3:
            errPass = null;
            break;
          case 4:
            errCPass = null;
            break;
        }
      });

  @override
  void dispose() {
    textNodes1.dispose();
    textNodes2.dispose();
    textNodes3.dispose();
    textNodes4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sign up",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SafeArea(
          minimum: EdgeInsets.only(left:10, right: 10, top: 10),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*SizedBox(height: 10),*/
              /*TextField(
                  autofocus: true,
                  maxLength: 20,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    errorText: errName,
                    counterText: "",
                  ),
                  focusNode: textNodes0,
                  onChanged: (String value){
                    setState(() {
                      name=value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    textNodes0.unfocus();
                    FocusScope.of(context).requestFocus(textNodes1);
                  },
                ),
              SizedBox(height: 10),*/
              TextField(
                  autofocus: true,
                  maxLength: 15,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    errorText: errUname,
                    counterText: "",
                    prefixText: "@",
                  ),
                  focusNode: textNodes1,
                  onChanged: (String value){
                    setState(() {
                      username=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    textNodes1.unfocus();
                    FocusScope.of(context).requestFocus(textNodes2);
                  },
                  onTap: () => clearErrText(1),
                ),
              SizedBox(height: 20),
              TextField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    errorText: errEmail,
                    counterText: "",
                  ),
                  focusNode: textNodes2,
                  onChanged: (String value){
                    setState(() {
                      email=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    textNodes2.unfocus();
                    FocusScope.of(context).requestFocus(textNodes3);
                  },
                  onTap: () => clearErrText(2),
                ),
                SizedBox(height: 10),
                TextField(
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          errorText: errPass,
                          suffixIcon: TextButton(
                            child: Icon(
                                passEye,
                                color: Colors.white54
                            ),
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                            ),
                            onPressed: ()=> setObscurePass(1),
                          ),
                        ),
                        focusNode: textNodes3,
                        onChanged: (String value){
                          setState(() {
                            pass = value;
                          });
                        },
                        obscureText: passObscure,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: (){
                          textNodes3.unfocus();
                          FocusScope.of(context).requestFocus(textNodes4);
                        },
                        onTap: () => clearErrText(3),
                      ),
                SizedBox(height: 10),
                TextField(
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm password",
                          errorText: errCPass,
                          suffixIcon: TextButton(
                            child: Icon(
                                cpassEye,
                                color: Colors.white54
                            ),
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                            ),
                            onPressed:() => setObscurePass(2),
                          ),
                        ),
                        onChanged: (String value){
                          setState(() {
                            cpass = value;
                          });
                        },
                        focusNode: textNodes4,
                        obscureText: cpassObscure,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: (){
                          textNodes4.unfocus();
                        },
                        onTap: () => clearErrText(4),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: signUpButton,
                    onPressed: ()
                    async {
                      checkUsername(); checkEmail(); checkPass(1); checkPass(2);
                      if(
                          errUname == null &&
                          errEmail == null &&
                          errPass == null &&
                          errCPass == null) {
                        setSignupButtonLoading(true);
                        String res = await My.i.auth.regUser(
                            email, pass, username, name: username);
                        setSignupButtonLoading(false);
                        if (res == null) {
                          await My.i.auth.getCurrentUser();
                          My.i.popup.inform(
                              context, "You have signed up successfully.");
                          await My.i.navigate.push(
                              context, "profile", popAllPage: true,);
                        }
                        else
                          My.i.popup.error(context, "Sign up failed. " + res);
                      }
                    },
                  )
            ],
          ),
      ),
    );
  }
}