import 'package:flutter/material.dart';
import 'package:goodtime/models/User.dart';
import 'package:goodtime/models/Picture.dart';

class ProfileRoute extends StatelessWidget
{
  final User user;
  final Picture picture;

  ProfileRoute({ Key key, this.user, this.picture });

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
      user.lastname + " " + user.firstname + " (" + user.username + ")",
      style: TextStyle(color: Colors.blueGrey),
    ),
  );

  /// Displays email
  Widget _showEmail() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    child: Text(
      user.email,
      style: TextStyle(color: Colors.blueGrey),
    ),
  );

  /// Displays body content
  Widget _showBody() => Center(
    child: Container(
      child: Column(
        children: <Widget>[
          _showProfilePicture(),
          _showName(),
          _showEmail()
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
      body: _showBody(),
    );
  }
}