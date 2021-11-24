// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_po_loadmore.dart';
import 'package:smartwarehouse_ocr_rfid/model/items_model.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/model/tag_model.dart';

class PoRepository {
  // static String mainUrl = 'http://192.168.0.100:7030'; //vpn
  // static String mainUrl = 'http://192.168.18.32:7030'; //PCDev
  Dio? _dio;

  ApiRepositary() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var mainUrl = localData.getString('access_token');
  }

  Future<POList> getAllPO() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('access_token');
    var getAllPOurl = '$mainUrl/v1/purchase-orders?cursor=';

    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    try {
      // Response<ResponseBody> rs;
      Response response = await _dio!.get(getAllPOurl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return POList.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return POList.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return POList.fromJson(error.response!.data);
      }
      // else if (error.type == DioErrorType.connectTimeout) {
      //   var body = {
      //     'message': 'Connection Timeout please check your local connection'
      //   };

      // }
      return POList.fromJson(error.response!.data);
    }
  }

  Future<dynamic> getPOLoadMore(String loadToken) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var getAllPOurl = '$mainUrl/v1/purchase-orders?cursor=';
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    try {
      print(getAllPOurl + loadToken);
      // Response<ResponseBody> rs;
      Response response = await _dio!.get(
        getAllPOurl + loadToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Connection': 'keep-alive',
          },
        ),
      );
      print(response.data);
      return POList.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return POList.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return POList.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.connectTimeout) {
        print('koneksi time out ---->>>>>> betul');
        EasyLoading.showError(
            'Connection Timeout please check your local connection',
            duration: Duration(seconds: 13));

        // getPOLoadmoreBloc..getallPOrx('');
        var body = {
          'message': 'Connection Timeout please check your local connection'
        };
        // var message = jsonEncode(toJson());
        return POList.fromJson(body);
      }
      return POList.fromJson(error.response!.data);
    }
  }

  Future<POList> search(String value) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var getSearchPOurl = '$mainUrl/v1/purchase-orders/search?search=';
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    // var params = {"search": value};
    try {
      Response response = await _dio!.get(getSearchPOurl + value.trim(),
          // queryParameters: params,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return POList.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return POList.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return POList.fromJson(error.response!.data);
      }
      return POList.fromJson(error.response!.data);
    }
  }

  Future<ItemsPOModel> searchItems(String query) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var getPOItemsurl = '$mainUrl/v1/purchase-orders/';
    String poNumber = localData.getString('poNumber').toString();
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    // var params = {"search": value};
    try {
      print(getPOItemsurl + poNumber + '/search-item?search=${query.trim()}');
      Response response = await _dio!
          .get(getPOItemsurl + poNumber + '/search-item?search=${query.trim()}',
              // queryParameters: params,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Connection': 'keep-alive',
                },
              ));
      print(response.data);
      return ItemsPOModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return ItemsPOModel.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return ItemsPOModel.fromJson(error.response!.data);
      }
      return ItemsPOModel.fromJson(error.response!.data);
    }
  }

  Future<ItemsPOModel> getPOItems(String? value) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var getPOItemsurl = '$mainUrl/v1/purchase-orders/';
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    // var params = {"search": value};
    try {
      print(' link to get item po : ${getPOItemsurl + "$value/items"}');
      Response response = await _dio!.get(getPOItemsurl + '$value/items',
          // queryParameters: params,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return ItemsPOModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return ItemsPOModel.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return ItemsPOModel.fromJson(error.response!.data);
      } else if (error.type == DioErrorType.connectTimeout) {
        print('koneksi time out ---->>>>>> betul');
        EasyLoading.showError(
            'Connection Timeout please check your local connection',
            duration: Duration(seconds: 13));

        // getPOLoadmoreBloc..getallPOrx('');
        var body = {
          'message': 'Connection Timeout please check your local connection'
        };
        // var message = jsonEncode(toJson());
        return ItemsPOModel.fromJson(body);
      }

      return ItemsPOModel.fromJson(error.response!.data);
    }
  }

  // ignore: missing_return
  Future<TagModel> postAssignTag(String recId, String uid) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var postAssignTagUrl = '$mainUrl/v1/rfids/';
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    // var params = {"search": value};
    try {
      print(
          ' link to get item po : ${postAssignTagUrl + "$recId/add-tag"} WITH UID :${uid.trim()}');
      Response response = await _dio!.post(postAssignTagUrl + "$recId/add-tag",
          data: {'uid': uid.trim()},
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return TagModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return TagModel.withError(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return TagModel.withError(error.response!.data);
      } else if (error.type == DioErrorType.connectTimeout) {
        print('koneksi time out ---->>>>>> betul');
        EasyLoading.showError(
            'Connection Timeout please check your local connection',
            duration: Duration(seconds: 13));

        // getPOLoadmoreBloc..getallPOrx('');
        var body = {
          'message': 'Connection Timeout please check your local connection'
        };
        // var message = jsonEncode(toJson());
        return TagModel.fromJson(body);
      }

      return TagModel.withError(error.response!.data);
    }
  }

  Future<TagModel> deletePO(
    String poNo,
  ) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = jsonDecode(localData.getString('access_token')!);
    var mainUrl = localData.getString('ipAddress');
    var getPOItemsurl = '$mainUrl/v1/purchase-orders/';
    BaseOptions options = new BaseOptions(
        baseUrl: "$mainUrl",
        receiveDataWhenStatusError: true,
        connectTimeout: 30 * 1000, // 60 seconds
        receiveTimeout: 30 * 1000 // 60 seconds
        );
    _dio = Dio(options);
    // var params = {"search": value};
    try {
      print(
          ' link to get item po : ${getPOItemsurl + "$poNo"} WITH UID :${poNo.trim()}');
      Response response = await _dio!.delete(getPOItemsurl + "${poNo.trim()}",
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              'Authorization': 'Bearer $token',
              'Connection': 'keep-alive',
            },
          ));
      print(response.data);
      return TagModel.fromJson(response.data);
    } on DioError catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      if (error.type == DioErrorType.response) {
        print(error.response!.data);
        return TagModel.withError(error.response!.data);
      } else if (error.type == DioErrorType.other) {
        return TagModel.withError(error.response!.data);
      } else if (error.type == DioErrorType.connectTimeout) {
        print('koneksi time out ---->>>>>> betul');
        EasyLoading.showError(
            'Connection Timeout please check your local connection',
            duration: Duration(seconds: 13));

        // getPOLoadmoreBloc..getallPOrx('');
        var body = {
          'message': 'Connection Timeout please check your local connection'
        };
        // var message = jsonEncode(toJson());
        return TagModel.fromJson(body);
      }
      return TagModel.withError(error.response!.data);
    }
  }
}
