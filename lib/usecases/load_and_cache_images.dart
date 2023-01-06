
import 'package:nytfeed/model/app_mode.dart';

abstract class LoadAndCacheImages {
  Future<Uri> getImage(AppMode mode, Uri remoteUri);
}