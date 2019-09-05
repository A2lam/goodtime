import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/User.dart';

class APIAuth {
  final String baseUrl = "http://10.0.2.2:3000";
  final storage = new FlutterSecureStorage(); // Creating the storage

  Future<String> signIn(String username, String password) async {
    var user;
    var response = await http.post(baseUrl + '/api/user/login', body: {
      "username": username,
      "password": password
    });

    if (response.statusCode == 200) {
      user = convert.jsonDecode(response.body);
      await storage.write(key: "token", value: user.token);
    }
    else {
      print("Request failed : ${response.statusCode}");
    }

    return user.user.id;
  }

  Future<String> signUp(String firstname, String lastname, String username, String email, String password) async {
    var user;
    var response = await http.post(baseUrl + '/users', body: {
      "firstname": firstname,
      "lastname": lastname,
      "username": username,
      "email": email,
      "password": password,
      "user_types_id": 3
    });

    if (response.statusCode == 200) {
      user = convert.jsonDecode(response.body);
    }
    else {
      print("Request failed : ${response.statusCode}");
    }

    return user.user.id;
  }

  Future<User> getCurrentUser() async {
    String token = await storage.read(key: "token"); // Reading the token value

    if (token != null) {
      User user = new User();
      Map<String, dynamic> userAttr = parseJwt(token);

      user.id = userAttr["id"];
      user.firstname = userAttr["firstname"];
      user.lastname = userAttr["lastname"];
      user.phone = userAttr["phone"];
      user.username = userAttr["username"];
      user.email = userAttr["email"];
      user.token = userAttr["token"];
      user.favorite_item = userAttr["favorite_item"];
      user.max_price = userAttr["max_price"];
      user.favorite_transportation = userAttr["favorite_transportation"];
      user.created_by = userAttr["created_by"];
      user.created_at = userAttr["created_at"];
      user.updated_by = userAttr["updated_by"];
      user.updated_at = userAttr["updated_at"];
      user.is_active = userAttr["is_active"];

      return user;
    }
    else {
      return null;
    }
  }

  void logOut() async {
    await storage.delete(key: "token"); // Deleting the user token
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = convert.jsonDecode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return convert.utf8.decode(convert.base64Url.decode(output));
  }
}