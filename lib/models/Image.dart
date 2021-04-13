
class ImageDoc{
  String id;
  String url;
  ImageDoc({this.id, this.url});
}
class ThumbnailDoc extends ImageDoc{
  ThumbnailDoc({String id, String url}){
    this.id = id;
    this.url = url;
  }
}
class ImageUrls{
  ImageDoc image;
  ThumbnailDoc thumbnail;
  ImageUrls({this.image, this.thumbnail});
}