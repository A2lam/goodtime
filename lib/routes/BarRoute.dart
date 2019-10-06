import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';
import 'package:goodtime/routes/BarDetailsRoute.dart';

class BarRoute extends StatefulWidget
{
  BarRoute({ Key key }) : super(key: key);

  final BarService _barService = new BarService();

  @override
  State<StatefulWidget> createState() => new _BarRouteState();
}

class _BarRouteState extends State<BarRoute>
{
  TextEditingController editingController = TextEditingController();
  List<Bar> _barList = new List<Bar>();
  List<Bar> _displayedBarList = new List<Bar>();

  /// Initializes
  @override
  void initState() {
    super.initState();
    _loadBars();
  }

  /// Loads all bars from the API
  void _loadBars() {
    widget._barService.getBars().then((bars) => setState(() {
      _barList = bars;
      _displayedBarList = bars;
    }));
  }

  /// Displays list of bars that contains the queried word
  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Bar> barSearchList = [];

      this._barList.forEach((bar) {
        if (bar.name.contains(query)) {
          barSearchList.add(bar);
        }
      });

      setState(() {
        _displayedBarList = barSearchList;
      });
    }
    else {
      setState(() {
        _displayedBarList = _barList;
      });
    }
  }

  /// Displays search bar
  Widget _showSearchBar() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: (value) {
          _filterSearchResults(value);
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

  /// Formats single bar in order to add it in the displayed list
  Widget _barToListItem(BuildContext context, Bar bar) => InkWell(
    onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => BarDetailsRoute(bar: bar))),
    child: Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Hero(
            tag: bar.name,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage("https://media.timeout.com/images/105190023/380/285/image.jpg"),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left:15.0),
              child: Text(
                bar.name,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          )
        ],
      ),
    ),
  );

  /// Displays the list of bars
  Widget _showBarList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _displayedBarList.length,
        itemBuilder: (BuildContext context, int index) {
          return _barToListItem(context, _displayedBarList[index]);
        }
      )
    );
  }

  /// Displays the page content
  Widget _showBody() {
    if (_displayedBarList.length > 0)
      return new Column(
        children: <Widget>[
          _showSearchBar(),
          _showBarList(),
        ],
      );
    else
      return new Column(
        children: <Widget>[
          _showSearchBar(),
          Container(
            child: Center(
              child: new Text(
                "Aucun bar trouvé",
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
            ),
          )
        ],
      );
  }

  /// Builds the screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: _showBody(),
      ),
    );
  }
}