import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e2_design/network_manager/custom_app_exceptions.dart';
import 'package:http/http.dart' as http;

import 'custom_app_exceptions.dart';

class ApiBaseHelper {
  final String _baseUrlProduction =
      "https://connected-brains.herokuapp.com/api/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrlProduction + url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Map body}) async {
    var responseJson;
    try {
      final response = await http.post(_baseUrlProduction + url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
