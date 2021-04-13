// import 'package:dummygram/bloc/UINavigator/Navigate.dart';
//
// import 'Singleton.dart';
// import 'ui/_all.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SplashUI extends StatefulWidget{
//   @override
//   _SplashUI createState() => _SplashUI();
// }
//
// class _SplashUI extends State<SplashUI>{
//
//   void registerPages() {
//     My.i.navigate.register("login", LoginUI());
//     My.i.navigate.register("profile", ProfileUI());
//     My.i.navigate.register("signup", SignupUI());
//     My.i.navigate.register("editprofile", EditProfileUI());
//   }
//   void init() async {
//     await My.i.auth.init();
//     await Future.delayed(Duration(milliseconds: 2500));
//     if (!My.i.globalSettings.authenticated) {
//       await My.i.navigate.push(context, "login", popAllPage: true);
//     } else {
//       await My.i.navigate.push(context, "profile", popAllPage: true);
//     }
//   }
//
//   @override
//   void initState() {
//     registerPages();
//     init();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Text(
//               "Dummygram",
//               style: Theme.of(context).textTheme.headline1,
//               ),
//             ),
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }