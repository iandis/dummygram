import 'dart:async';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';


import 'package:dummygram/bloc/CachedImage/ICachedImage.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List> loadImageFromDisk(String path) async {
  Uint8List res;
  await File(path).readAsBytes()
      .then((value) => res = value)
      .catchError((Object err) { res = null; print("loadImageFromDisk " + err.toString());});

  return res;
}

Future<bool> saveImageToDisk(List args/*String path, Uint8List image*/) async {
  bool res;
  await File(args[0]).writeAsBytes(args[1])
      .then((value) => value == null ? res = false: res = true)
      .catchError((Object err) { res = false; print("saveImageToDisk " + err.toString()); });
  return res;
}

class CachedImage implements ICachedImage{
  static const platform = const MethodChannel('dummygram.android/lrucache');
  String cachePath;

  @override
  Future<void> init() async{
    await getTemporaryDirectory().then((value) => cachePath = value.path);
    print(cachePath);
  }

  Future<bool> handleDir(String dir) async{
    final Directory directory = Directory(dir);
    if(await directory.exists()){
      return true;
    }else{
      try {
        await directory.create(recursive: true);
        return true;
      }catch(e){
        print(e.toString());
        return false;
      }

    }
  }

  ///Cache 0 -> temporary
  ///Cache 1 -> as long as app lives
  @override
  Future<Uint8List> loadImageUrl(String url, String path, int whichCache) async{
    path = cachePath + "/" + path;
    var dir = p.dirname(path);
    Uint8List fromMemory = whichCache == 0
        ?
          await platform.invokeMethod("getFromCache0", path)
        :
          await platform.invokeMethod("getFromCache1", path) ;

    print(path);
    if(fromMemory != null) {
      print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! from memory");
      return fromMemory; //if it's in memory cache
    }

    print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! not from memory");
    var handle = await handleDir(dir);
    if(!handle){
      print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! handleDir ? " + handle.toString());
      return null;
    }

    var fromDisk = await compute(loadImageFromDisk, path );
    //if it's not in disk
    if(fromDisk == null) {
      //download the image
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {

        var bodyBytes = res.bodyBytes;
        //add to memory cache
        if(whichCache == 0)
          await platform.invokeMethod("addToCache0", [path, bodyBytes]);
        else
          await platform.invokeMethod("addToCache1", [path, bodyBytes]);

        var saved = await compute(saveImageToDisk, [path, bodyBytes]); // save to disk
        print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! from url: saved ? "+saved.toString());
        return bodyBytes;

      } else {
        print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! failed to download");
        return null;
      }
    //if it's in disk
    }else{
      //add to memory cache
      if (whichCache == 0)
        await platform.invokeMethod("addToCache0", [path, fromDisk]);
      else
        await platform.invokeMethod("addToCache1", [path, fromDisk]);

      print("[COM.AVOPROJECTS.DUMMYGRAM] (Logs) ! from disk");
      return fromDisk;
    }
  }

  //@override
  // Future<Uint8List> loadImageFromDisk(String path) async {
  //   Uint8List res;
  //   await File(cachePath + "/" + path).readAsBytes()
  //     .then((value) => res = value)
  //     .catchError((Object err) => res = null);
  //
  //   return res;
  // }

  //@override
  // Future<bool> saveImageToDisk(List args/*String path, Uint8List image*/) async {
  //   bool res;
  //   await File(cachePath + "/" + args[0]).writeAsBytes(args[1])
  //       .then((value) => value == null ? res = false: res = true)
  //       .catchError((Object err) => res = false);
  //   return res;
  // }

  @override
  Future<bool> invalidateCache(int which) async {
    if(which == 0){
      return await platform.invokeMethod("clearCache0");
    }else{
      return await platform.invokeMethod("clearCache1");
    }
  }

}