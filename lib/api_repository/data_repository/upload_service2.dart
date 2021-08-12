import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/model/upload_response.dart';

class UploadProgress with ChangeNotifier {
  var _progress = 0.0;
  double get progress => _progress;

  void start({
    @required String url,
    @required List<MultipartFile> multiPartfile,
  }) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token'));

    final payload = FormData.fromMap({
      'image': multiPartfile,
    });

    Response response = await Dio().post<String>(url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Connection': 'keep-alive',
          },
        ), onSendProgress: (sent, total) {
      var pos = sent / total * 100;
      _updateProgress(pos);
    });
    print('response upload : $response');
    UploadPOResponse.fromJson(response.data);
  }

  void _resetProgress() {
    if (progress != 0) {
      _progress = 0;
      notifyListeners();
    }
  }

  void _updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }
}
