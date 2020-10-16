import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final _httpClient = HttpClient();

Future<String> getRequest(Uri uri) async {
  var request = await _httpClient.getUrl(uri);
  var response = await request.close();

  return response.transform(utf8.decoder).join();
}

Future<String> getRequestWithHeaders(Uri uri, Map<String, dynamic> headers) async {
  var request = await _httpClient.getUrl(uri);

  headers.forEach((header, value) => request.headers.set(header, value));

  var response = await request.close();
  return response.transform(latin1.decoder).join();
}

Future<http.StreamedResponse> postRequestWithHeaders(Uri uri, Map<String, dynamic> fields, Map<String, dynamic> headers) async {
  var request = new http.MultipartRequest("POST", uri);
  headers.forEach((header, value) => request.headers[header] = value);
  fields.forEach((field, value) => request.fields[field] = value);

  return request.send();
}
