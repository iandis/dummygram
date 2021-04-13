import 'dart:typed_data';
import 'package:dummygram/models/Image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dummygram/bloc/UserDb/IUserDb.dart';
import 'package:dummygram/models/User.dart';

class UserDb implements IUserDb{

  @override
  Future<List> getUserProfile({String uId}) async {
    if(FirebaseAuth.instance.currentUser == null) return ["User is not logged in.", null];
    String err;
    UserInf res = UserInf();
    res.id = FirebaseAuth.instance.currentUser.uid;
    var uid = uId == null ? res.id : uId;
    await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .get()
                          .then((DocumentSnapshot result){
                                res.name = result["name"];
                                res.username = result["username"];
                                res.bio = result["bio"];
                                res.imgurl128 = result["imgurl128"];
                                res.imgurl64 = result["imgurl64"];
                                res.flwr = result["flwr"];
                                res.flwg = result["flwg"];
                          }).onError((error, stackTrace) {err = error; res = null;});
    return [err, res];
  }

  @override
  Future<List> setUserProfile(UserInf userInf) async {
    if(FirebaseAuth.instance.currentUser == null) return [false, "User is not logged in."];
    String err;
    bool res = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: userInf.username)
          .get()
          .then((value) =>
      value.size > 0
          ? throw("Username already taken.")
          : null);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userInf.id)
          .set({
                "name" : userInf.name,
                "username" : userInf.username,
                "bio" : userInf.bio,
                "imgurl128": userInf.imgurl128,
                "imgurl64": userInf.imgurl64,
                "flwr" : userInf.flwr,
                "flwg" : userInf.flwg,
          });
    }catch(e){
      res = false;
      err = e.toString();
    }
    return [res, err];
  }

  @override
  Future<List> uploadImgAndThumbnail(
      String path,
      String fileName,
      String fileThumb,
      Uint8List fileBytes,
      Uint8List thumbBytes,
      {bool addToGallery = true}) async {
    bool err = false; List<String> urls = [];
    try {
      for (int i = 1; i <= 2; i++) {
        await FirebaseStorage.instance.ref(path)
            .child(i == 1 ? fileName : fileThumb)
            .putData(i == 1 ? fileBytes : thumbBytes)
            .then((snapshot) async {
              await snapshot.ref
                  .getDownloadURL()
                  .then((value) => urls.add(value));
        });
      }

      if (addToGallery) {
        var uid = FirebaseAuth.instance
            .currentUser.uid;
        var doc = FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("gallery")
            .doc();
        await doc.set({
              "id": doc.id,
              "url": urls[0],
              "thumbnail": urls[1],
              "createdOn": FieldValue.serverTimestamp(),
        });
      }
    }catch(e){
      err = true;
    }
    return [err, urls[0], urls[1]];
  }

  /*@override
  Future< List<String> > uploadMultiFiles(
      String path,
      List<String> fileNames,
      List<Uint8List> files,
      {bool addToGallery = true}) async {
    List<String> res = [];
    for(int i=0; i < fileNames.length; i++){

      var upload = await uploadImgAndThumbnail(path, fileNames[i], files[i], addToGallery: addToGallery);
      if(upload[0]){
        res = null; break;
      }
      res.add(upload[1]);
    }
    return res;
  }*/

  @override
  Future<List<String>> getProfileImage({String uId}) async {
    if(FirebaseAuth.instance.currentUser == null) return null;
    List<String> res = [];
    String uid = uId == null ? FirebaseAuth.instance.currentUser.uid : uId;
    await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .get()
                            .then((value) {
                              res.add(value["imgurl128"]);
                              res.add(value["imgurl64"]);
                            })
                            .catchError((Object err) => res = null);
    return res;
  }

  @override
  Future<List<ThumbnailDoc>> getGallery({String uId}) async{
    if(FirebaseAuth.instance.currentUser == null) return null;
    List<ThumbnailDoc> res = [];
    String uid = uId == null ? FirebaseAuth.instance.currentUser.uid : uId;

    await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection("gallery")
                            .orderBy("createdOn", descending: true)
                            .get()
                            .then((query) {
                              query.docs.forEach((docs) {
                                var doc = ThumbnailDoc(id: docs["id"], url: docs["thumbnail"]);
                                res.add(doc);
                              });
                            })
                            .catchError((Object err) => res = null);
    return res;
  }

  @override
  Future<ImageDoc> getImage(String docId, {String uId}) async{
    if(FirebaseAuth.instance.currentUser == null) return null;
    ImageDoc res;
    String uid = uId == null ? FirebaseAuth.instance.currentUser.uid : uId;

    await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection("gallery")
                            .doc(docId)
                            .get()
                            .then((value) => res = ImageDoc(id: value["id"], url: value["url"]) )
                            .catchError((Object e) => null);
    return res;
  }

  @override
  Future<String> changeUserPassword(String email, String oldPass, String newPass) async {
    String res;
    var cred = EmailAuthProvider.credential(email: email, password: oldPass);
    await FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(cred)
        .then((user) async {
          await user.user.updatePassword(newPass);
          await FirebaseAuth.instance.currentUser.reload();
        })
        .catchError((Object error){
          if(error is FirebaseAuthException)
            res = error.message;
          else
            res = error.toString();
        }
    );
    return res;
  }
}