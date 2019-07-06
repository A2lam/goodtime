import 'package:flutter/material.dart';
import 'package:goodtime/services/BaseAuth.dart';
import 'package:goodtime/models/Todo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePageRoute extends StatefulWidget {
  HomePageRoute({ Key key, this.auth, this.userId, this.onSignedOut })
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageRouteState();
}

class _HomePageRouteState extends State<HomePageRoute> {
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Vérifiez votre compte"),
          content: new Text("Merci de bien vouloir valider votre compte à l'aide du lien envoyé"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Renvoyer le lien"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifiez votre compte"),
          content: new Text("Le lien de vérification a été envoyé à votre boîte mail"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showWelcomeMessage() {
    return new Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Bienvenue sur Goodtime',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _showBody() {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        _showLogo(),
        _showWelcomeMessage()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Goodtime'),
        backgroundColor: Colors.amber[200],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('GoodTime'),
              decoration: BoxDecoration(color: Colors.amber[200]
              ),
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Rechercher un bar'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Mes bars favoris'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Mes réservations'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Paramètres'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Déconnexion'),
              onTap: () => _signOut(),
            ),
          ],
        ),
      ),
      body: _showBody(),
    );
  }
}