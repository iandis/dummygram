import 'package:firebase_auth/firebase_auth.dart';
import 'package:dummygram/models/User.dart';
class GlobalSettings{
  static final GlobalSettings me = GlobalSettings();
  User currentUser;
  UserInf userInfo = UserInf();
  bool get authenticated => currentUser != null;
  GlobalSettings();
}