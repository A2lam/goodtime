import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/Bar.dart';

class BarService
{
  final String _baseUrl = "http://192.168.0.11:3000/bars";
  final _storage = new FlutterSecureStorage();

  /// Returns list of all bars from API
  Future<List<Bar>> getBars() async {
    String token = await _storage.read(key: "token");
    List<Bar> barList = new List<Bar>();
    var bars;

    var response = await http.get(_baseUrl, headers: { HttpHeaders.authorizationHeader: "bearer " + token });

    if (response.statusCode == 200) {
      bars = convert.jsonDecode(response.body);
      for (var bar in bars) {
        barList.add(Bar.fromJson(bar));
      }
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return barList;
  }

  /// Return one bar from API with its id
  Future<Bar> getBar(int id) async {
    String token = await _storage.read(key: "token");
    Bar requestedBar = new Bar();
    var bar;

    var response = await http.get(_baseUrl + "/$id", headers: { HttpHeaders.authorizationHeader: "bearer " + token });

    if (response.statusCode == 200) {
      bar = convert.jsonDecode(response.body);
      requestedBar = Bar.fromJson(bar);
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return requestedBar;
  }
}