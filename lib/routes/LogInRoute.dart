import 'package:flutter/material.dart';
import 'package:goodtime/services/APIAuthentication.dart';
import 'package:goodtime/routes/SignUpRoute.dart';

class LogInRoute extends StatefulWidget {
  LogInRoute({ this.auth, this.onSignedIn });

  final APIAuthentication auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LogInRouteState();
}

class _LogInRouteState extends State<LogInRoute> {
  final _formKey = new GlobalKey<FormState>();
  String _username;
  String _password;
  String _errorMessage;
  bool _isLoading;
  bool _isIos;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  // Check if the form is valid before proceeding login or signUp
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      int userId;
      try {
        userId = await widget.auth.signIn(_username, _password);
        print('Signed in: $userId');

        if (null != userId) {
          widget.onSignedIn();
        }
      }
      catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          }
          else {
            _errorMessage = e.message;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Connexion",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.amber[200],
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showLogo(),
            _showUsernameInput(),
            _showPasswordInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return new Center(
        child: CircularProgressIndicator(),
      );
    }

    return new Container(
      height: 0.0,
      width: 0.0,
    );
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

  Widget _showUsernameInput () {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Nom d\'utilisateur',
          icon: Icon(
            Icons.account_circle,
            color: Colors.grey,
          )
        ),
        validator: (value) => value.isEmpty ? 'Vous devez renseigner un nom d\'utilisateur' : null,
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget _showPasswordInput () {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Mot de passe',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          )
        ),
        validator: (value) => value.isEmpty ? 'Vous devez renseigner un mot de passe' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: new SizedBox(
        height: 42.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          color: Colors.amber[200],
          child: Text(
            'Connexion',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black
            )
          ),
          onPressed: _validateAndSubmit,
        )
      )
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: Text(
        'Créer un nouveau compte',
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300
        )
      ),
      onPressed: () {
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => SignUpRoute(auth: widget.auth, onSignedIn: widget.onSignedIn)),
        );
      },
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300
        ),
      );
    }
    else {
      return new Container(
        height: 0.0,
      );
    }
  }
}