import 'package:flutter/material.dart';
import 'package:goodtime/routes/HomePageRoute.dart';
import 'package:goodtime/routes/LogInRoute.dart';
import 'package:goodtime/services/BaseAuth.dart';

class AppRootRoute extends StatefulWidget {
  AppRootRoute({ this.auth });

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _AppRootRouteState();
}

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN }

class _AppRootRouteState extends State<AppRootRoute> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (null != user) {
          _userId = user?.uid;
        }
        authStatus = null == user?.uid ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onSignedOut() {
    setState(() {
      _userId = "";
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;

      case AuthStatus.NOT_LOGGED_IN:
        return new LogInRoute(
            auth: widget.auth,
            onSignedIn: _onLoggedIn,
        );
        break;

      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && null != _userId) {
          return new HomePageRoute(
            auth: widget.auth,
            userId: _userId,
            onSignedOut: _onSignedOut,
          );
        }
        else {
          return _buildWaitingScreen();
        }
        break;

      default:
        return _buildWaitingScreen();
    }
  }
}