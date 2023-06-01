import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mastech/helpers/shared_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../models/login_details.dart';

class PdfService {
  static Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    try {
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  static Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getExternalStorageDirectory();
      final file = File('${appStorage!.path}/$name');
       LoginDetails details = await SharedService().getLoginDetails();
      String token = details.token!;
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
           headers: {'Content-Type': 'application/json', 'Authorization': token},
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

}
