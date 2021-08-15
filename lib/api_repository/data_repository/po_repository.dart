import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';

class PoRepository {
  static String mainUrl = 'http://100.68.1.2:7030';
  final Dio _dio = Dio();

  var getAllPOurl = '$mainUrl/v1/purchase-orders';
  var getSearchPOurl = '$mainUrl/v1/purchase-orders/search?search=';

  Future<POList> getAllPO() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token'));
    try {
      // Response<ResponseBody> rs;
      Response response = await _dio.get(getAllPOurl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return POList.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stacktrrace:$stacktrace");
      return error;
    }
  }

  Future<POList> search(String value) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token'));
    // var params = {"search": value};
    try {
      Response response = await _dio.get(getSearchPOurl + value,
          // queryParameters: params,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return POList.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return error;
    }
  }
}
