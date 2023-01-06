
import 'package:nytfeed/data/file_service.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/usecases/load_and_cache_images.dart';
import 'package:uuid/uuid.dart';

class LoadAndCacheImagesImpl extends LoadAndCacheImages {
  final FileService _fileService;

  LoadAndCacheImagesImpl(this._fileService);

  @override
  Future<Uri> getImage(AppMode mode, Uri remoteUri) async {
    final cacheDir = await _fileService.getCacheDir();
    final filename = const Uuid().v5(Uuid.NAMESPACE_NIL, remoteUri.toString());
    final cachedFilename = Uri.parse("$cacheDir$filename");

    if (await _fileService.isExists(cachedFilename)) {
      return cachedFilename;
    }

    if (mode == AppMode.online) {
      final data = await _fileService.load(remoteUri);
      await _fileService.save(cachedFilename, data);
      return cachedFilename;
    }

    throw Exception("No image available");
  }

}