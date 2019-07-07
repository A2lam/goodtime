import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';

class BarRoute extends StatefulWidget {
  BarRoute({ Key key }) : super(key: key);

  BarService _barService = new BarService();

  @override
  State<StatefulWidget> createState() => new _BarRouteState();
}

class _BarRouteState extends State<BarRoute> {
  TextEditingController editingController = TextEditingController();
  List<Bar> _barList;

  @override
  void initState() {
    _barList = widget._barService.getAll();
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Bar> duplicatedBarList = [];
    duplicatedBarList.addAll(_barList);

    if (query.isNotEmpty) {
      List<Bar> barSearchList = [];

      duplicatedBarList.forEach((bar) {
        if (bar.name.contains(query)) {
          barSearchList.add(bar);
        }
      });

      setState(() {
        _barList.clear();
        _barList.addAll(barSearchList);
      });
    }
    else {
      setState(() {
        _barList.clear();
        _barList.addAll(duplicatedBarList);
      });
    }
  }

  Widget _showSearchBar() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value);
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

  Widget _showBarList() {
    return new Expanded(
        child: ListView.builder(
          itemCount: _barList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_barList[index].name}'),
            );
          },
        )
    );
  }

  Widget _showBody() {
    return new Column(
      children: <Widget>[
        _showSearchBar(),
        _showBarList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bars'),
        backgroundColor: Colors.amber[200],
      ),
      body: Container(
        child: _showBody(),
      ),
    );
  }
}