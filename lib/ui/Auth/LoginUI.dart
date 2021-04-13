import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../Singleton.dart';
class LoginUI extends StatefulWidget{
  @override
  _LoginUI createState()=>_LoginUI();

}
class _LoginUI extends State<LoginUI>{
  String email, pass, errEmail, errPass;
  bool passObscure = true;
  Widget loginButton = Text("Log me in");
  IconData passEye = Icons.visibility_off_outlined;

  checkEmail()=>
    setState(() {
      errEmail = !My.i.validators.isValidEmail(email) ? "Email is not valid" : null;
    });

  checkPass()=>
    setState(() {
      if(My.i.validators.isValidPassword(pass) == -1)
        errPass = "cannot be empty.";
      else if(My.i.validators.isValidPassword(pass) == 0)
        errPass = "must be at least 8 characters";
      else
        errPass = null;
    });
  setLoginButtonLoading(bool loading) =>
      setState((){
        if(loading)
          loginButton = SizedBox(
              height: 15,
              width: 15,
              child:
              CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
              )
          );
        else
          loginButton = Text("Log me in");
      });
  setObscurePass()=>
      setState((){
        passObscure = !passObscure;
        passEye = passObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined;
        }
      );
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
            margin: EdgeInsets.all(10),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Welcome",
                  style: Theme.of(context).textTheme.headline3,
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
                  onChanged: (String value){
                    setState(() {
                      email=value.toLowerCase();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    node.nextFocus();
                    },
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
                      onPressed:() => setObscurePass(),
                    ),
                  ),
                  onChanged: (String value){
                    setState(() {
                      pass = value;
                    });
                  },
                  obscureText: passObscure,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    node.unfocus();
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                child: loginButton,
                onPressed:  ()
                async {
                  checkEmail(); checkPass();
                        if(errEmail == null &&
                            errPass == null){
                          setLoginButtonLoading(true);
                          var result = await My.i.auth.loginUser(email, pass);
                          setLoginButtonLoading(false);
                          if(result == null) {
                            My.i.popup.inform(context, "Welcome back !");
                            await My.i.auth.getCurrentUser();
                            /*setLoginButtonLoading(true);
                            var avatar = await My.i.auth.initUserAvatar();
                            setLoginButtonLoading(false);*/
                            await My.i.navigate.push(
                                context, "profile", popAllPage: true);
                          }
                          else
                            My.i.popup.error(context, "Login failed. Incorrect email or password.");
                        }
                      },
              ),
              SizedBox(height: 10),
              Text(
                    "or",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                ),
              TextButton(
                  child: Text(
                    "Sign up",
                    style: TextStyle(decoration: TextDecoration.underline)),
                    onPressed: () async {
                    await My.i.navigate.push(context, "signup");
                  },
                ),
              /*),*/
            ],
          ),
      ),
    );
  }
}