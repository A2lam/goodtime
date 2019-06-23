import 'package:flutter/material.dart';
import 'package:goodtime/services/BaseAuth.dart';

class SignupAndLoginRoute extends StatefulWidget {
  SignupAndLoginRoute({ this.auth, this.onSignedIn });

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _SignupAndLoginRouteState();
}

enum FormMode { LOGIN, SIGNUP }

class _SignupAndLoginRouteState extends State<SignupAndLoginRoute> {
  final _formKey = new GlobalKey<FormState>();
  FormMode _formMode;
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading;
  bool _isIos;

  @override
  void initState() {
    _formMode = FormMode.LOGIN;
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Vérifiez votre boîte mail"),
          content: new Text("Un lien de vérification vous y a été envoyé"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password); 
          print('Signed in: $userId');
        }
        else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }

        if (userId.length > 0 && userId.length != null) {
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
        title: Text("Login"),
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
            _showEmailInput(),
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

  Widget _showEmailInput () {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          )
        ),
        validator: (value) => value.isEmpty ? 'Vous devez renseigner un email' : null,
        onSaved: (value) => _email = value,
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
          child: _formMode == FormMode.LOGIN ?
            Text(
                'Connexion',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                )
            ) :
            Text(
                'Créer un nouveau compte',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                )
            )
          ,
          onPressed: _validateAndSubmit,
        )
      )
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN ?
        Text(
          'Créer un nouveau compte',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300
          )
        ) :
        Text(
          'Vous avez un compte ? Connectez vous',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300
          )
        )
      ,
      onPressed: _formMode == FormMode.LOGIN ? _changeFormToSignUp : _changeFormToLogin,
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