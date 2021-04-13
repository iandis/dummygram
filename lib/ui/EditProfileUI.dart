import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as Img;

import '../Singleton.dart';

Future<List<Uint8List>> getImageAndThumbnailBytes(File image) async {
  List<Uint8List> res = [];
  try {
    var imageBytes = await image.readAsBytes();
    var imgImg = Img.decodeImage(imageBytes);
    var thumbnailImg = Img.copyResize(imgImg, width: 64, height: 64);
    var thumbnailBytes = thumbnailImg.getBytes();
    res.add(imageBytes); //128x128
    res.add(thumbnailBytes); //64x64
  }catch(e){
    res = null;
  }
  return res;
}

class EditProfileUI extends StatefulWidget{

  @override
  _EditProfileUI createState()=> _EditProfileUI();
}

class _EditProfileUI extends State<EditProfileUI>{
  String name, username, bio, email, pass, cpass;
  StreamSubscription<User> userSub;
  ScrollController _scrollController = ScrollController();
  Uint8List avatar = My.i.globalSettings.userInfo.avatar128;
  String avatarPath;
  List<Uint8List> img;

  /// Get from gallery
  Future<void> _getFromGallery() async {
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg']);
    if(pickedFile != null) {
      if(pickedFile.isSinglePick)
        img = await _cropImage(pickedFile.files.single.path);
        if(img != null)
          setState(() {
            avatar = img[0]; //image 128 x 128
          });
      else {
        My.i.popup.error(context, "Please select 1 file only.");
      }
    }
  }

  /// Crop Image
  Future<List<Uint8List>> _cropImage(String filePath) async {
    List<Uint8List> res;
    File image = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 128,
        maxHeight: 128,
        compressQuality: 75,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          statusBarColor: Colors.transparent,
          backgroundColor: Colors.white,
        ),
    );
    if(image != null)
      res = await compute(getImageAndThumbnailBytes, image);

    return res;
  }

  @override
  void initState() {
    userSub = FirebaseAuth.instance.authStateChanges().listen((event) async =>
    event ?? await userSignOut()
    );
    super.initState();
  }
  @override
  void dispose() async {
    await userSub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  userSignOut() async {
    My.i.globalSettings.userInfo.clear();
    await My.i.navigate.push(
        context, "login", popAllPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () async {
                        await _getFromGallery();
                      },
                      child:CircleAvatar(
                        radius: 62,
                        backgroundColor: Colors.cyanAccent,
                        child: CircleAvatar(
                            radius: 60,
                            backgroundImage:  avatar == null ?
                                              AssetImage("assets/images/default_avatar.png") :
                                              MemoryImage(avatar)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0),
                child: Text(
                  My.i.globalSettings.userInfo.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:3.0),
                child: Text(
                  "@"+My.i.globalSettings.userInfo.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:20, right:20,top:30.0, bottom: 30),
                child: Text(
                  My.i.globalSettings.userInfo.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 1,
                color: Colors.white12,
              ),
              IntrinsicHeight(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                      flex:1,
                      child: Container(
                          padding: EdgeInsets.only(top:6,bottom: 9,),
                          child:Column(
                            children: [
                              Text(
                                "0",
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Posts",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.white12,
                    ),
                    Expanded(
                      flex:1,
                      child: Container(
                          padding: EdgeInsets.only(top:6,bottom: 9,),
                          child:Column(
                            children: [
                              Text(
                                My.i.globalSettings.userInfo.flwr.length.toString(),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Followers",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.white12,
                    ),
                    Expanded(
                      flex:1,
                      child: Container(
                          padding: EdgeInsets.only(top:6,bottom: 9,),
                          child:Column(
                            children: [
                              Text(
                                My.i.globalSettings.userInfo.flwg.length.toString(),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Following",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 30,
                thickness: 1,
                color: Colors.white12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}