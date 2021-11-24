import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  var baseUrl;
  String? endPoint;
  var token;

  late Dio dio;

  _getToken() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    token = json.decode(localData.getString('access_token')!);
  }

  _getIP() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    baseUrl = localData.getString('ipAddress')!;
    endPoint = "$baseUrl/v1/auth/login";
    print('just get ip: $endPoint');
  }

  authData(data) async {
    await _getIP();
    var fullEndpoint = endPoint;

    return await http
        .post(Uri.parse(fullEndpoint!),
            body: jsonEncode(data), headers: _setHeaders())
        .timeout(const Duration(seconds: 45), onTimeout: () {
      return http.Response('Connection Time Out', 500);
    });
  }

  getData() async {
    await _getIP();
    var fullEndpoint = endPoint;
    await _getToken();
    return await http.get(Uri.parse(fullEndpoint!), headers: _setHeaders());
  }

  getData2(apiParameter) async {
    await _getIP();
    var fullEndpoint = endPoint! + apiParameter;
    await _getToken();
    return await dio.get(fullEndpoint);
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        // 'Accept': '*/*',
        // 'Authorization': 'Bearer $token'
      };
}
