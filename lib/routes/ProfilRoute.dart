import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:goodtime/models/User.dart';
import 'package:goodtime/models/Picture.dart';
import 'package:goodtime/services/APIAuthentication.dart';

class ProfileRoute extends StatefulWidget
{
  final User user;
  final Picture picture;
  final VoidCallback onSignedOut;
  final APIAuthentication auth = new APIAuthentication();

  ProfileRoute({ Key key, this.user, this.picture, this.onSignedOut });

  @override
  State<StatefulWidget> createState() => new ProfileRouteState();
}

class ProfileRouteState extends State<ProfileRoute>
{
  /// Disconnect the user
  _signOut(BuildContext context) {
    widget.auth.signOut();
    widget.onSignedOut();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  /// Displays deletion successful message
  Future<Widget> _showSuccessfulMessage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Votre compte a été supprimé succès",
              style: TextStyle(color: Colors.greenAccent),
            ),
            content: Center(
              child: Text("Vos données sont conservés et seront définitivement supprimés dans un mois."),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => _signOut(context),
                  child: Text('Ok')
              ),
            ],
          );
        }
    );
  }

  /// Displays deletion error message
  Future<Widget> _showErrorDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Erreur lors de la suppression",
              style: TextStyle(color: Colors.redAccent),
            ),
            content: Center(
              child: Text("Une erreur s'est produite lors de la suppression du compte"),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok')
              ),
            ],
          );
        }
    );
  }

  /// Deletes user account
  Future<void> _deleteAccount(BuildContext context, int usersId) async {
    bool userDeleted = await widget.auth.deleteUser(usersId);
    if (userDeleted) {
      _showSuccessfulMessage(context);
    }
    else {
      _showErrorDialog(context);
    }
  }

  /// Displays profile picture
  Widget _showProfilePicture() => Container(
    padding: EdgeInsets.all(10.0),
    child: Hero(
      tag: Text("Utilisateur"),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(""),
      ),
    ),
  );

  /// Displays firstName, lastName & username
  Widget _showName() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    child: Text(
      widget.user.lastname + " " + widget.user.firstname + " (" + widget.user.username + ")",
      style: TextStyle(color: Colors.blueGrey),
    ),
  );

  /// Displays email
  Widget _showEmail() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    child: Text(
      widget.user.email,
      style: TextStyle(color: Colors.blueGrey),
    ),
  );

  /// Displays remove bar from favorite button
  Widget _showDeleteAccountButton(BuildContext context) => Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30.0),
        child: FloatingActionButton.extended(
          heroTag: "showDelAccBtn",
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.delete_forever),
          label: Text("Supprimer mon compte"),
          onPressed: () => _deleteAccount(context, widget.user.id),
        ),
      )
  );

  /// Displays body content
  Widget _showBody(BuildContext context) => Center(
    child: Container(
      child: Column(
        children: <Widget>[
          _showProfilePicture(),
          _showName(),
          _showEmail(),
          _showDeleteAccountButton(context)
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: _showBody(context),
    );
  }
}