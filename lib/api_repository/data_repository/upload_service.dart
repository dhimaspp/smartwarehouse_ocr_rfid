import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/model/upload_response.dart';
// import 'package:http/http.dart';

class UploadPOService {
  static String mainUrl = "http://192.168.18.170:7030";

  static Future<dynamic> uploadPOService(
      List<MultipartFile> multiPartfile) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token'));
    final Dio _dio = Dio();
    var postRegister = "$mainUrl/v1/purchase-orders";
    var formdata = FormData.fromMap({
      "image": multiPartfile,
    });

    try {
      // Response<ResponseBody> rs;
      Response response = await _dio.post(
        postRegister,
        data: formdata,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Connection': 'keep-alive',
          },
        ),
        onSendProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },

        // responseType: ResponseType.stream),
      );
      // rs = response.data;
      // print('-------------------${rs.data!.stream}');
      print('response upload : $response');
      return UploadPOResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stacktrrace:$stacktrace");
      return error.toString();
    }
  }
}
