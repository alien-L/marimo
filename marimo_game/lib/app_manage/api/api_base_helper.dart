import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

class ApiBaseHelper {
  ApiBaseHelper();

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    Uri uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post({
    required String authority,
    required String unEncodedPath,
    required List<dynamic> params,
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    final data = <String, dynamic>{};

    for (var entry in params) {
      if (entry != null) {
        data.addAll(entry.toJson());
      }
    }

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.https(authority, unEncodedPath),
        headers: headers,
        body: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw BadRequestException(message: response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(message: response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          message: 'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
