import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../data/model/network_response.dart';


class NetworkCaller {
  /// GET request method
  static Future<NetworkResponse> getRequest(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
       // headers: headers ?? _defaultHeaders(),
      );
     // _logRequest('GET', url, response);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
       // _handleUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          data: null,
          message: 'Session expired',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          data: null,
          message: response.body,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }


}
