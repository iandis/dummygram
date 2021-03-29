
import 'package:dummygram/models/User.dart';

class IAuth{
  Future<void> init() async {}
  void getCurrentUser(){}
  void setCurrentUser(UserInf userInf){}
  Future<List> loginUser(String email, String password) async{}
  Future<String> regUser(UserInf userInf, String password) async{}
  void signOut(){}
}