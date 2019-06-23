import 'package:flutter/material.dart';
import 'package:goodtime/services/Authentication.dart';
import 'package:goodtime/routes/SignupAndLoginRoute.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goodtime Login',
      /*theme: ThemeData(
        primarySwatch: Colors.amber,
      ),*/
      home: new SignupAndLoginRoute(auth: new Authentication())
    );
  }
}