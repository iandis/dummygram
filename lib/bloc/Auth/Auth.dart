import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'IAuth.dart';
import '../../Singleton.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Auth implements IAuth{

  @override
  init() async{
    await Firebase.initializeApp();
  }

  @override
  Future<Uint8List> initUserAvatar() async{
    var url = My.i.globalSettings.userInfo.imgurl128;
    var avatarPath = "users/"+My.i.globalSettings.userInfo.id+"/128x128.jpg";
    Uint8List avatar;
    if(url != ""){
      avatar = await My.i.cachedImage.loadImageUrl(url, avatarPath, 1);
    }
    return avatar;
  }

  @override
  StreamSubscription listenToUserChange(FutureOr<dynamic> onSignOut) {
    return FirebaseAuth.instance.userChanges().listen((event) => event ?? onSignOut);
  }

/*  void _setcurrentUser(User user, FutureOr onSignIn, FutureOr onSignOut) async{
    if(user != null){
      var uid = user.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((DocumentSnapshot result){
              My.i.globalSettings.userInfo.id=uid;
              My.i.globalSettings.userInfo.name = result["name"];
              My.i.globalSettings.userInfo.bio = result["bio"];
              My.i.globalSettings.userInfo.imgUrl = result["imgurl"];
              My.i.globalSettings.userInfo.flwr = result["flwr"];
              My.i.globalSettings.userInfo.flwg = result["flwg"];
          })
          .whenComplete(() => onSignIn);
    }else{
      My.i.globalSettings.userInfo.clear();
      await onSignOut;
    }
  }*/
  @override
  Future<int> getCurrentUser() async{
    var auth = FirebaseAuth.instance.currentUser;
    int err;
    if(auth != null){
      var uid = auth.uid;
      await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get()
                            .then((DocumentSnapshot result)async{
                              My.i.globalSettings.userInfo.id=uid;
                              My.i.globalSettings.userInfo.name = result["name"];
                              My.i.globalSettings.userInfo.username = result["username"];
                              My.i.globalSettings.userInfo.bio = result["bio"];
                              My.i.globalSettings.userInfo.imgurl128 = result["imgurl128"];
                              My.i.globalSettings.userInfo.imgurl64 = result["imgurl64"];
                              My.i.globalSettings.userInfo.flwr = List.from(result["flwr"]);
                              My.i.globalSettings.userInfo.flwg = List.from(result["flwg"]);
                              var url = result["imgurl128"];
                              var thumb = result["imgurl64"];
                              var avatarPath1 = "users/"+uid+"/128x128.jpg";
                              var avatarPath2 = "users/"+uid+"/64x64.jpg";
                              Uint8List avatar1, avatar2;
                              if(url != "")
                                avatar1 = await My.i.cachedImage.loadImageUrl(url, avatarPath1, 0);

                              if(thumb != "")
                                avatar2 = await My.i.cachedImage.loadImageUrl(thumb, avatarPath2, 0);

                              My.i.globalSettings.userInfo.avatar128 = avatar1;
                              My.i.globalSettings.userInfo.avatar64 = avatar2;
                              print("[Called From GetCurrentUser !");
      })
                            .then((value) => err = 1)
                            .catchError((Object error) => err = -1);
    }else{
      err = 0;
      My.i.globalSettings.userInfo.clear();
    }
    return err;
  }

/*  @override
  void setCurrentUser(UserInf userInf) {
    My.i.globalSettings.userInfo.id = userInf.id;
    My.i.globalSettings.userInfo.name = userInf.name;
    My.i.globalSettings.userInfo.bio = userInf.bio;
    My.i.globalSettings.userInfo.imgUrl = userInf.imgUrl;
    My.i.globalSettings.userInfo.flwr = userInf.flwr;
    My.i.globalSettings.userInfo.flwg = userInf.flwg;
  }*/

  @override
  Future<String> loginUser(String email, String password) async {
    //UserInf userInf = UserInf();
    String res;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.toLowerCase(), password: password)
        .then((value) => res = null)
        .catchError((Object error) {
          if(error is FirebaseException)
            res = error.message;
          else
            res = error.toString();
        })
        .whenComplete(() async => res ?? await getCurrentUser());
    return res;
  }

  @override
  Future<String> regUser(String email, String password, String username, {String name = ""}) async{
    String res;
    String id, _name;
    //FieldValue serverTime = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)        
        .get()
        .then((value) => value.size > 0 ? throw("Username already taken.") : null)
        .then((_) async
          {
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email, password: password)
                .then( (regUser) async
                  {
                    id = regUser.user.uid;
                    _name = name == "" ? email.split('@')[0] : name;
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(id)
                        .set(
                          {
                            "name" : _name,
                            "username" : username,
                            "bio"  : "",
                            "imgurl128": "",
                            "imgurl64": "",
                            "flwr" : [],
                            "flwg" : [],
                            "createdOn" : FieldValue.serverTimestamp(),
                          }
                        );
                  }
                );
        })
        .catchError((Object error) {
          if(error is FirebaseException)
            res = error.message;
          else
            res = error.toString();
        })
        .whenComplete(() async => res ?? await getCurrentUser());
    return res;
  }

/*  @override
  Future<void> signOut() async {
    if(FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut().then((value) => My.i.globalSettings.userInfo.clear());
    }else{

    }
  }*/
}