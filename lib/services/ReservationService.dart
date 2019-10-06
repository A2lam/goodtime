import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodtime/models/GoodTime.dart';

class ReservationService
{
  final String _baseUrl = "http://10.0.2.2:3000/good_times";
  final _storage = new FlutterSecureStorage();
}