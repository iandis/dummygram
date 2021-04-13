import 'dart:async';

import 'package:dummygram/models/User.dart';

class IAuth{
  init() {}
  initUserAvatar() {}
  listenToUserChange(FutureOr<dynamic> onSignOut){}
  getCurrentUser(){}
  // setCurrentUser(UserInf userInf){}
  loginUser(String email, String password) async{}
  regUser(String email, String password, String username, {String name = ""}) {}
/*  signOut(){}*/
}