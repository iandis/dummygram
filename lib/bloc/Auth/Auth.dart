import 'package:dummygram/models/User.dart';
import 'IAuth.dart';
import 'package:dummygram/GlobalSettings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Auth implements IAuth{
  Auth();
  @override
  Future<void> init() async{
    await Firebase.initializeApp();
    GlobalSettings.me.currentUser = FirebaseAuth.instance.currentUser;
    getCurrentUser();
  }

  @override
  void getCurrentUser() async{
    if(GlobalSettings.me.authenticated){
      var uid = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get()
                            .then((DocumentSnapshot result){
                              GlobalSettings.me.userInfo.id=uid;
                              GlobalSettings.me.userInfo.name = result["name"];
                              GlobalSettings.me.userInfo.email = result["email"];
                              GlobalSettings.me.userInfo.bio = result["bio"];
                              GlobalSettings.me.userInfo.imgUrl = result["imgurl"];
                              GlobalSettings.me.userInfo.flwr = result["flwr"];
                              GlobalSettings.me.userInfo.flwg = result["flwg"];
                              });
    }else{
      GlobalSettings.me.userInfo = UserInf();
    }
  }

  @override
  void setCurrentUser(UserInf userInf) {
    GlobalSettings.me.userInfo.id = userInf.id;
    GlobalSettings.me.userInfo.name = userInf.name;
    GlobalSettings.me.userInfo.email = userInf.email;
    GlobalSettings.me.userInfo.bio = userInf.bio;
    GlobalSettings.me.userInfo.imgUrl = userInf.imgUrl;
    GlobalSettings.me.userInfo.flwr = userInf.flwr;
    GlobalSettings.me.userInfo.flwg = userInf.flwg;
  }

  @override
  Future<List> loginUser(String email, String password) async {
    UserInf userInf = UserInf();
    String res;
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
        .whenComplete(() {setCurrentUser(userInf);})
        .onError((error, stackTrace) {res = error.toString();});
    return [res, userInf];
  }

  @override
  Future<String> regUser(UserInf userInf, String password) async{
    String res;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: userInf.email, password: password)
        .then((regUser) async {
          userInf.id = regUser.user.uid;
            await FirebaseFirestore.instance
              .collection("users")
              .doc(userInf.id)
              .set({
            "name" : userInf.name,
            "email": userInf.email,
            "bio"  : userInf.bio,
            "imgurl": userInf.imgUrl,
            "flwr" : userInf.flwr,
            "flwg" : userInf.flwg});
          })
              .whenComplete(() {setCurrentUser(userInf);})
              .onError((error, stackTrace) {res=error.toString();});
    return res;
  }

  @override
  void signOut() async {
    if(FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      GlobalSettings.me.userInfo = UserInf();
    }
  }
}