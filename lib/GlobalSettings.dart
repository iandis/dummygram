import 'package:firebase_auth/firebase_auth.dart';
import 'package:dummygram/models/User.dart';
class GlobalSettings{
  static GlobalSettings instance() => new GlobalSettings();
  User currentUser;
  UserInf userInfo = new UserInf();
  bool authenticated() => currentUser != null;
}