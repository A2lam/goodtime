import 'package:flutter/material.dart';
import 'package:goodtime/services/APIAuthentication.dart';
import 'package:goodtime/routes/BarRoute.dart';
import 'package:goodtime/routes/MapBarRoute.dart';

class HomePageRoute extends StatefulWidget
{
  HomePageRoute({ Key key, this.auth, this.userId, this.onSignedOut })
      : super(key: key);

  final APIAuthentication auth;
  final VoidCallback onSignedOut;
  final int userId;

  @override
  State<StatefulWidget> createState() => new _HomePageRouteState();
}

class _HomePageRouteState extends State<HomePageRoute>
    with SingleTickerProviderStateMixin
{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);
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
            child: new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              accountName: null,
              accountEmail: null,
              currentAccountPicture: new CircleAvatar(
                backgroundColor: const Color(0xFF778899),
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            // decoration: BoxDecoration(color: Colors.amber[200]),
          ),
          ListTile(
            title: Text('Profil'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Trouver un bar'),
            onTap: () {
              Navigator.push(
                this.context,
                MaterialPageRoute(builder: (context) => BarRoute()),
              );
            },
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
          new BarRoute(),
          new MapBarRoute(),
        ],
      ),
    );
  }
}