import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/Bar.dart';

class BarService
{
  final String _baseUrl = "http://10.0.2.2:3000/bars";
  final _storage = new FlutterSecureStorage();

  Future<List<Bar>> getBars() async {
    String token = await _storage.read(key: "token");
    List<Bar> barList;
    var bars;

    var response = await http.get(_baseUrl, headers: { HttpHeaders.authorizationHeader: token });

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
}