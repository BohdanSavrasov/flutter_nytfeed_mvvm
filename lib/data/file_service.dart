
import 'dart:typed_data';

abstract class FileService {
  Future<Uint8List> load(Uri uri);
  Future<void> save(Uri uri, Uint8List data);
  Future<Uri> getCacheDir();
  Future<bool> isExists(Uri uri);
}