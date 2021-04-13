import 'package:dummygram/bloc/Auth/Auth.dart';
import 'package:dummygram/bloc/UINavigator/Navigate.dart';
import 'package:dummygram/bloc/Validators/Validators.dart';
import 'package:dummygram/bloc/Popup/Popup.dart';
import 'GlobalSettings.dart';
import 'bloc/CachedImage/CachedImage.dart';
import 'bloc/UserDb/UserDb.dart';

class My{
  Auth auth = Auth();
  Navigate navigate = Navigate();
  Validators validators = Validators();
  Popup popup = Popup();
  GlobalSettings globalSettings = GlobalSettings();
  CachedImage cachedImage = CachedImage();
  UserDb userDb = UserDb();
  static final My i = My();
}