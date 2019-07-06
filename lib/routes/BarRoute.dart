import 'package:flutter/material.dart';

class BarRoute extends StatefulWidget {
  BarRoute({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _BarRouteState();
}

class _BarRouteState extends State<BarRoute> {
  TextEditingController editingController = TextEditingController();

  Widget _showSearchBar() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: (value) {

        },
        controller: editingController,
        decoration: InputDecoration(
          labelText: "Recherche",
          hintText: "Rechercher un bar ...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          )
        ),
      ),
    );
  }

  //Widget _showBarList() {

  //}

  Widget _showBody() {
    return new Column(
      children: <Widget>[
        _showSearchBar(),
        //_showBarList(),
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
      body: Container(
        child: _showBody(),
      ),
    );
  }
}