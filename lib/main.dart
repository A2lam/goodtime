import 'package:flutter/material.dart';
import 'package:goodtime/services/APIAuthentication.dart';
import 'package:goodtime/routes/AppRootRoute.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goodtime',
      theme: ThemeData(
        // primarySwatch: Colors.amber[200],
        fontFamily: 'Muli'
      ),
      home: new AppRootRoute(auth: new APIAuthentication())
    );
  }
}