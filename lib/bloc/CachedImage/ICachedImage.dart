import 'dart:io';

class ICachedImage{
  //init({int threshold0 = 67108864 /*64 mb*/, int threshold1 = 67108864 /* 64 mb */ }){}
  init(){}
  loadImageUrl(String url, String path, int whichCache){}
  invalidateCache(int which){}
  // loadImageFromDisk(String path){}
  // saveImageToDisk(List args){}
  //getImageAndThumbnailBytes(File image){}
}