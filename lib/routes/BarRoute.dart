import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';
import 'package:goodtime/routes/BarDetailsRoute.dart';

class BarRoute extends StatefulWidget
{
  BarRoute({ Key key }) : super(key: key);

  BarService _barService = new BarService();

  @override
  State<StatefulWidget> createState() => new _BarRouteState();
}

class _BarRouteState extends State<BarRoute>
{
  TextEditingController editingController = TextEditingController();
  List<Bar> _barList = new List<Bar>();

  @override
  void initState() {
    super.initState();
    widget._barService.getBars().then((bars) => _barList = bars);
  }

  // TODO : RÉGLER LE SOUCIS DE LA DUPLICATION DE LISTE
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

  Widget makeListTile(Bar bar) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0, color: Colors.white24)
        )
      ),
      child: Icon(Icons.autorenew, color: Colors.black),
    ),
    title: Text(
      bar.name,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    // TODO : Quand faudra rajouter un sous-titre
    /*subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              // tag: 'hero',
              child: LinearProgressIndicator(
                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                  value: lesson.indicatorValue,
                  valueColor: AlwaysStoppedAnimation(Colors.green)),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(lesson.level,
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),*/

    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
    onTap: () {
      Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => BarDetailsRoute(bar: bar))
      );
    },
  );

  Widget makeCard(Bar bar) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.grey[200]), // Color.fromRGBO(64, 75, 96, .9)
      child: makeListTile(bar),
    ),
  );

  Widget _showBarList() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _barList.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_barList[index]);
        }
      )
    );
  }

  Widget _showBody() {
    if (_barList.length > 0)
      return new Column(
        children: <Widget>[
          _showSearchBar(),
          _showBarList(),
        ],
      );
    else
      return new Container(
        child: Center(
          child: new Text(
            "Aucun bar trouvé",
            style: TextStyle(
              fontSize: 20.0
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: _showBody(),
      ),
    );
  }
}