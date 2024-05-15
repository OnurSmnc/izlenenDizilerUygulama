import 'dart:convert';
import 'package:odev_3/models/dizi.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DosyaIslemi {
  const DosyaIslemi();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/diziler.txt');
  }

  Future<List<Dizi>> dizileriOku() async {
    try {
      List<Dizi> diziler = [];
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      for (Map<String, dynamic> m in jsonDecode(contents)) {
        diziler.add(Dizi.fromJson(m));
      }

      return diziler;
    } catch (e) {
      return [];
    }
  }

  Future<File> dizileriYaz(String json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json);
  }
}
