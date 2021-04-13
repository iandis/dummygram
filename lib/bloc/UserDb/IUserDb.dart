import 'dart:typed_data';

import 'package:dummygram/models/User.dart';
import 'dart:io';
class IUserDb{
  getUserProfile(){}
  setUserProfile(UserInf userInf){}
  changeUserPassword(String email, String oldPass, String newPass){}
  uploadImgAndThumbnail(
      String path,
      String fileName,
      String fileThumb,
      Uint8List fileBytes,
      Uint8List thumbBytes,
      {bool addToGallery = true}
      ){}
  //uploadMultiFiles(String path,  List<String> fileNames, List<Uint8List> files, {bool addToGallery = true}){}
  getProfileImage({String uId}){}
  getGallery({String uId}){}
  getImage(String docId, {String uId}){}
}