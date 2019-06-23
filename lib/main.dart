import 'package:flutter/material.dart';
import 'package:goodtime/services/FirebaseAuthentication.dart';
import 'package:goodtime/routes/AppRootRoute.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goodtime',
      /*theme: ThemeData(
        primarySwatch: Colors.amber,
      ),*/
      home: new AppRootRoute(auth: new FirebaseAuthentication())
    );
  }
}