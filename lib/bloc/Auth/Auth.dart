import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummygram/models/User.dart';
import 'IAuth.dart';
import 'package:dummygram/GlobalSettings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Auth implements IAuth{
  static Auth instance() => new Auth();

  @override
  Future<void> init() async{
    await Firebase.initializeApp();
    GlobalSettings.instance().currentUser = FirebaseAuth.instance.currentUser;
    getCurrentUser();
  }

  @override
  void getCurrentUser() async{
    if(GlobalSettings.instance().authenticated()){
      var uid = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get()
                            .then((DocumentSnapshot result){
                              GlobalSettings.instance().userInfo.id=uid;
                              GlobalSettings.instance().userInfo.name = result["name"];
                              GlobalSettings.instance().userInfo.email = result["email"];
                              GlobalSettings.instance().userInfo.bio = result["bio"];
                              GlobalSettings.instance().userInfo.imgUrl = result["imgurl"];
                              GlobalSettings.instance().userInfo.flwr = result["flwr"];
                              GlobalSettings.instance().userInfo.flwg = result["flwg"];
                              });
    }else{
      GlobalSettings.instance().userInfo = null;
    }
  }

  @override
  void setCurrentUser(UserInf userInf) {
    GlobalSettings.instance().userInfo = userInf;
  }

  @override
  Future<bool> loginUser(String email, String password) async {
    UserInf userInf;
    bool res;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.toLowerCase(), password: password)
        .then((logUser) async {
                          userInf.id = logUser.user.uid;
                          await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userInf.id)
                                          .get()
                                          .then((DocumentSnapshot result){
                                            userInf.name = result["name"];
                                            userInf.email = result["email"];
                                            userInf.bio = result["bio"];
                                            userInf.imgUrl = result["imgurl"];
                                            userInf.flwr = result["flwr"];
                                            userInf.flwg = result["flwg"];
                          });
                        }
        )
        .whenComplete(() {setCurrentUser(userInf); res = true;})
        .onError((error, stackTrace) {res = false;});
    return res;
  }

  @override
  Future<bool> regUser(UserInf userInf, String password) async{
    bool res;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userInf.email, password: password)
        .then((regUser) async { userInf.id = regUser.user.uid;
                              await FirebaseFirestore.instance
                                .collection("users")
                                .doc(userInf.id)
                                .set(
                                {
                                  "name" : userInf.name,
                                  "email": userInf.email,
                                  "bio"  : userInf.bio,
                                  "imgurl": userInf.imgUrl,
                                  "flwr" : userInf.flwr,
                                  "flwg" : userInf.flwg,
                                });}
        )
        .whenComplete(() {setCurrentUser(userInf); res=true;})
        .onError((error, stackTrace) {res=false;});
    return res;
  }

  @override
  void signOut() async {
    if(FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      GlobalSettings.instance().userInfo = null;
    }
  }
}