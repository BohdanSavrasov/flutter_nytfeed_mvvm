
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:nytfeed/data/file_service.dart';
import 'package:path_provider/path_provider.dart';

class FileServiceImpl extends FileService {

  @override
  Future<Uint8List> load(Uri uri) async {
    final res = await http.get(uri);

    if (res.statusCode ~/ 100 != 2) {
      throw Exception(res.reasonPhrase);
    }

    return res.bodyBytes;
  }

  @override
  Future<void> save(Uri uri, Uint8List data) async {
    await File(uri.toFilePath()).writeAsBytes(data);
  }

  @override
  Future<Uri> getCacheDir() async {
    return (await getTemporaryDirectory()).uri;
  }

  @override
  Future<bool> isExists(Uri uri) {
    return File(uri.toFilePath()).exists();
  }

}