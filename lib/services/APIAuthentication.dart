import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/User.dart';

class APIAuthentication
{
  final String _baseUrl = "http://192.168.0.11:3000";
  final _storage = new FlutterSecureStorage(); // Creating the storage

  Future<int> signIn(String username, String password) async {
    var user;

    Map body = {
      'username': username,
      'password': password
    };

    var response = await http.post(_baseUrl + '/api/user/login',
        headers: {"Content-Type": "application/json"},
        body: convert.json.encode(body)
    );

    if (response.statusCode == 200) {
      user = convert.jsonDecode(response.body);
      await _storage.write(key: "token", value: user["token"]);

      return user["user"]["id"];
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }
  }

  Future<int> signUp(String firstname, String lastname, String username, String email, String password) async {
    Map body = {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'password': password,
      'user_types_id': 3
    };

    var response = await http.post(_baseUrl + '/users',
        headers: {"Content-Type": "application/json"},
        body: convert.json.encode(body)
    );

    if (response.statusCode == 200) {
      return this.signIn(username, password);
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }
  }

  Future<User> getCurrentUser() async {
    String token = await _storage.read(key: "token") ?? null; // Reading the token value
    
    if (this.isTokenExpired(token))
      return null;

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

      return user;
    }
    else {
      return null;
    }
  }

  void signOut() async {
    await _storage.delete(key: "token"); // Deleting the user token
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

  int getTokenExpirationDate(token) {
    Map<String, dynamic> decoded = parseJwt(token);
  
    if (null == decoded["exp"]) return null;
  
    return decoded["exp"];
  }

  bool isTokenExpired(token) {
    if(null == token)
      return true;
    
    double date = this.getTokenExpirationDate(token).toDouble();
    if(null == date) return false;
    double now = new DateTime.now().millisecondsSinceEpoch / 1000;
    return !(date > now);
  }
}