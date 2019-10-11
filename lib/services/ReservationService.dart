import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/services/APIConnection.dart';
import 'package:goodtime/models/GoodTime.dart';

class ReservationService
{
  final String _baseUrl = APIConnection.getAPIUrl() + "/good_times";
  final _storage = new FlutterSecureStorage();

  /// Create a reservation
  Future<GoodTime> createReservation(int bars_id, DateTime date, int number_of_participants, { int groups_id = null }) async {
    String token = await _storage.read(key: "token");
    GoodTime goodTime;

    Map body = {
      'bars_id': bars_id,
      'date': date.toString(),
      'number_of_participants': number_of_participants,
      'groups_id': groups_id,
      'status': 'SOU'
    };

    var response = await http.post(_baseUrl,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "bearer " + token
        },
        body: convert.json.encode(body)
    );

    if (response.statusCode == 200) {
      var jsonGT = convert.jsonDecode(response.body);
      goodTime = GoodTime.fromJson(jsonGT["good_time"]);
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return goodTime;
  }

  /// Get all user's reservations
  Future<List<GoodTime>> getReservations() async {
    String token = await _storage.read(key: "token");
    List<GoodTime> reservationList = new List<GoodTime>();
    var reservations;

    var response = await http.get(_baseUrl, headers: { HttpHeaders.authorizationHeader: "bearer " + token });

    if (response.statusCode == 200) {
      reservations = convert.jsonDecode(response.body);
      for (var reservation in reservations) {
        reservationList.add(GoodTime.fromJson(reservation));
      }
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return reservationList;
  }

  /// Get a specific reservation
  Future<GoodTime> getReservation(int goodTimesId) async {
    String token = await _storage.read(key: "token");
    GoodTime requestedGT = new GoodTime();
    var goodTime;

    var response = await http.get(_baseUrl + "/$goodTimesId", headers: { HttpHeaders.authorizationHeader: "bearer " + token });

    if (response.statusCode == 200) {
      goodTime = convert.jsonDecode(response.body);
      requestedGT = GoodTime.fromJson(goodTime);
    }
    else {
      print("Request failed : ${response.statusCode}");

      return null;
    }

    return requestedGT;
  }

  /// Cancels a reservation
  Future<bool> cancelReservation(int reservationsId) async {
    String token = await _storage.read(key: "token");

    var response = await http.delete(_baseUrl + "/$reservationsId",
        headers: { HttpHeaders.authorizationHeader: "bearer " + token }
    );

    if (response.statusCode == 200) {
      var reservationCanceled = convert.jsonDecode(response.body);
      if (reservationCanceled["return"] == "OK")
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