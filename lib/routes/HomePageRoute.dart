import 'package:flutter/material.dart';
import 'package:goodtime/models/Picture.dart';
import 'package:goodtime/models/User.dart';
import 'package:goodtime/services/APIAuthentication.dart';
import 'package:goodtime/routes/BarRoute.dart';
import 'package:goodtime/routes/MapBarRoute.dart';
import 'package:goodtime/routes/ReservationRoute.dart';
import 'package:goodtime/routes/ProfilRoute.dart';

class HomePageRoute extends StatefulWidget
{
  final APIAuthentication auth;
  final VoidCallback onSignedOut;
  final int userId;
  final bool isFavBarScreen;

  HomePageRoute({ Key key, this.auth, this.userId, this.onSignedOut, this.isFavBarScreen })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePageRouteState();
}

class _HomePageRouteState extends State<HomePageRoute>
    with SingleTickerProviderStateMixin
{
  TabController _tabController;
  User _user;
  Picture _userPicture;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);
    widget.auth.getCurrentUser().then((user) => setState(() => _user = user));
    // TODO : Manque une ligne ici pour la récupération de la photo
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() {
    widget.auth.signOut();
    widget.onSignedOut();
  }

  Widget _menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Hero(
                  tag: Text("Utilisateur"),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/logo.png"),
                  ),
                ),
              ),
            ), // decoration: BoxDecoration(color: Colors.amber[200]),
          ),
          ListTile(
            title: Text('Profil'),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(builder: (context) => ProfileRoute(user: _user, picture: null, onSignedOut: widget.onSignedOut)),
              );
            },
          ),
          ListTile(
            title: Text('Trouver un bar'),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(builder: (context) => HomePageRoute(
                  auth: widget.auth,
                  onSignedOut: widget.onSignedOut,
                  userId: widget.userId,
                  isFavBarScreen: false,
                )),
              );
            },
          ),
          ListTile(
            title: Text('Mes bars favoris'),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(builder: (context) => HomePageRoute(
                  auth: widget.auth,
                  onSignedOut: widget.onSignedOut,
                  userId: widget.userId,
                  isFavBarScreen: true,
                )),
              );
            },
          ),
          ListTile(
            title: Text('Mes réservations'),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(builder: (context) => ReservationRoute()),
              );
            },
          ),
          ListTile(
            title: Text('Déconnexion'),
            onTap: () => _signOut(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Goodtime'),
        elevation: 7.0,
        // backgroundColor: Colors.amber[200],
        bottom: new TabBar(
          controller: _tabController,
          // labelColor: Colors.black45,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.view_list)),
            new Tab(icon: new Icon(Icons.map))
          ],
        ),
      ),
      drawer: _menu(),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new BarRoute(isFavBarScreen: widget.isFavBarScreen),
          new MapBarRoute(isFavBarScreen: widget.isFavBarScreen),
        ],
      ),
    );
  }
}