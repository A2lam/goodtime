import 'package:flutter/material.dart';
import 'package:goodtime/models/GoodTime.dart';
import 'package:goodtime/services/ReservationService.dart';

class ReservationRoute extends StatefulWidget
{
  ReservationRoute({ Key key }) : super(key: key);

  final ReservationService _reservationService = new ReservationService();

  @override
  State<StatefulWidget> createState() => new _ReservationRouteState();
}

class _ReservationRouteState extends State<ReservationRoute>
{
  TextEditingController editingController = TextEditingController();
  List<GoodTime> _reservationList = new List<GoodTime>();
  List<GoodTime> _displayedReservationList = new List<GoodTime>();

  /// Initializes
  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  /// Loads all reservations from the API
  void _loadReservations() {
    widget._reservationService.getReservations().then((reservations) => setState(() {
      _reservationList = reservations;
      _displayedReservationList = reservations;
    }));
  }

  /// Displays list of reservation that contains the queried word
  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<GoodTime> reservationSearchList = [];

      this._reservationList.forEach((reservation) {
        if (reservation.bar.name.contains(query)) {
          reservationSearchList.add(reservation);
        }
      });

      setState(() {
        _displayedReservationList = reservationSearchList;
      });
    }
    else {
      setState(() {
        _displayedReservationList = _reservationList;
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

  /// Formats single reservation in order to add it in the displayed list
  Widget _reservationToListItem(BuildContext context, GoodTime reservation) => InkWell(
    //onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => BarDetailsRoute(bar: bar))),
    onTap: () => {},
    child: Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Hero(
            tag: reservation.bar.name,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage("https://media.timeout.com/images/105190023/380/285/image.jpg"),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left:15.0),
              child: Text(
                reservation.bar.name + " => " + reservation.date.day.toString() + "/" + reservation.date.month.toString() + "/" + reservation.date.year.toString() + " " +reservation.date.hour.toString() + ":" + reservation.date.minute.toString(),
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          )
        ],
      ),
    ),
  );

  /// Displays the list of reservation
  Widget _showReservationList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _displayedReservationList.length,
        itemBuilder: (BuildContext context, int index) {
          return _reservationToListItem(context, _displayedReservationList[index]);
        }
      )
    );
  }

  /// Displays the page content
  Widget _showBody() {
    if (_displayedReservationList.length > 0)
      return new Column(
        children: <Widget>[
          _showSearchBar(),
          _showReservationList(),
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
      appBar: new AppBar(
        title: new Text('Réservations'),
      ),
      body: Container(
        child: _showBody(),
      ),
    );
  }
}