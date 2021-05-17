import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  final String endPoint = "";
  var token;
  Dio? dio;

  _getToken() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    token = json.decode(localData.getString('token')!)['token'];
  }

  authData(data, apiParameter) async {
    var fullEndpoint = endPoint + apiParameter;

    return await http.post(Uri.parse(fullEndpoint),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiParameter) async {
    var fullEndpoint = endPoint + apiParameter;
    await _getToken();
    return await http.get(Uri.parse(fullEndpoint), headers: _setHeaders());
  }

  getData2(apiParameter) async {
    var fullEndpoint = endPoint + apiParameter;
    await _getToken();
    return await dio!.get(fullEndpoint);
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
