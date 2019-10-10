import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';

class FavBarService
{
  final String _baseUrl = "http://10.0.2.2:3000/favorite_bars";
  final _storage = new FlutterSecureStorage();
  final _barService = new BarService();

  Future<List<Bar>> getFavBars() async {
    String token = await _storage.read(key: "token");
    List<Bar> favBarList = new List<Bar>();
    var favBars;

    var response = await http.get(_baseUrl, headers: { HttpHeaders.authorizationHeader: "bearer " + token });

    if (response.statusCode == 200) {
      favBars = convert.jsonDecode(response.body);
      for (var favBar in favBars) {
        _barService.getBar(favBar["bar"]["id"]).then((bar) => favBarList.add(bar));
      }
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return favBarList;
  }
}