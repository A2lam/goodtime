import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';

class FavBarService
{
  final String _baseUrl = "http://192.168.0.11:3000/favorite_bars";
  final _storage = new FlutterSecureStorage();
  final _barService = new BarService();

  /// Get user's favorites bars
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

  /// Check if bar par from user fav bars
  Future<bool> isBarFav(int barsId) async {
    String token = await _storage.read(key: "token");

    var response = await http.get(_baseUrl + "/$barsId",
      headers: { HttpHeaders.authorizationHeader: "bearer " + token }
    );

    if (response.statusCode == 200) {
      var jsonFavBar;
      if (!["", null, false, 0].contains(response.body)) {
        jsonFavBar = convert.jsonDecode(response.body);
      }
      if (null != jsonFavBar && 0 != jsonFavBar.length)
        return true;
      else
        return false;
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }
  }

  /// Mark bar as favorite
  Future<bool> addFavBar(int barsId) async {
    String token = await _storage.read(key: "token");

    Map body = {
      'bars_id': barsId,
    };

    var response = await http.post(_baseUrl,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "bearer " + token
        },
        body: convert.json.encode(body)
    );

    if (response.statusCode == 200) {
      var jsonFavBar = convert.jsonDecode(response.body);
      if (null != jsonFavBar)
        return true;
      else
        return false;
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }
  }

  /// Remove bar from favorite
  Future<bool> removeFavBar(int barsId) async {
    String token = await _storage.read(key: "token");

    var response = await http.delete(_baseUrl + "/$barsId",
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "bearer " + token
        }
    );

    if (response.statusCode == 200) {
      var jsonFavBar = convert.jsonDecode(response.body);
      if (jsonFavBar["return"] == "OK")
        return true;
      else
        return false;
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }
  }
}