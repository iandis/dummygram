import 'dart:typed_data';

class UserInf{
  String id;
  String name;
  String username;
  String bio;
  String imgurl128;
  String imgurl64;
  List flwr;
  List flwg;
  Uint8List avatar128;
  Uint8List avatar64;

  UserInf({
    this.id,
    this.name,
    this.username,
    this.bio,
    this.imgurl128,
    this.flwr,
    this.flwg,
    this.avatar128,
    this.avatar64,
  });
  void clear(){
    id = null;
    username = null;
    name = null;
    imgurl128 = null;
    imgurl64 = null;
    bio = null;
    if(flwr != null ) flwr.clear();
    if(flwg != null ) flwg.clear();
    avatar128 = null;
    avatar64 = null;
  }
}