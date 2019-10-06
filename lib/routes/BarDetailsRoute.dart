import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/routes/SingleReservationRoute.dart';

class BarDetailsRoute extends StatefulWidget
{
  final Bar bar;

  BarDetailsRoute({ Key key, this.bar }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _BarDetailsRouteState();
}

class _BarDetailsRouteState extends State<BarDetailsRoute>
{
  /// Generates new horizontal divider
  Widget _horizontalDivider() => new Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: Divider(
        color: Colors.grey,
        height: 36,
      )
  );

  /// Generates new vertical divider
  Widget _verticalDivider() => new Container(
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    color: Colors.grey,
    height: 20,
    width: 1,
  );

  /// Displays the avatar
  Widget _showAvatar() => Container(
    padding: EdgeInsets.all(16),
    child: Hero(
      tag: widget.bar.name,
      child: CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage("https://media.timeout.com/images/105190023/380/285/image.jpg"),
      ),
    ),
  );

  /// Displays the bar's name
  Widget _showBarName() => Text(
    widget.bar.name,
    style: TextStyle(fontSize: 22),
  );

  /// Displays bar's address
  Widget _showBarAddress() => Row(
    children: <Widget>[
      Icon(Icons.location_on),
      Text(
        widget.bar.address.number.toString() + " " + widget.bar.address.street + ", " + widget.bar.address.post_code.toString() + " " + widget.bar.address.city,
        style: TextStyle(fontSize: 11.0),
      )
    ],
  );

  /// Displays bar's phone number
  Widget _showBarPhoneNumber() => Row(
    children: <Widget>[
      Icon(Icons.phone),
      Text(
        widget.bar.phone,
        style: TextStyle(fontSize: 11.0),
      )
    ],
  );

  /// Displays bar's contact info
  Widget _showBarContactInfo() => Container(
    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Center(
      child: Row(
        children: <Widget>[
          _showBarAddress(),
          _verticalDivider(),
          _showBarPhoneNumber()
        ],
      ),
    ),
  );

  /// Displays bar's description
  Widget _showBarDescription() => Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    child: Text(
      widget.bar.description,
      style: TextStyle(fontSize: 16),
    ),
  );

  /// Displays button to personal reservation
  Widget _showPersonalReservationButton() => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.person),
        label: Text("Réservation personnelle"),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleReservationRoute(bar: widget.bar))),
      ),
    ),
  );

  /// Displays button to group reservation
  Widget _showGroupReservationButton() => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.greenAccent,
        icon: Icon(Icons.group),
        label: Text("Réservation de groupe"),
        onPressed: () => {},
      ),
    ),
  );

  /// Displays chose reservation type dialog
  Future<Widget> _displayReservationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Réservation'),
            content: Column(
              children: <Widget>[
                _showPersonalReservationButton(),
                _showGroupReservationButton()
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Annuler')
              ),
            ],
          );
        }
    );
  }

  /// Displays reservations button
  Widget _showReservationButton(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        icon: Icon(Icons.insert_invitation),
        label: Text("Réserver"),
        onPressed: () => _displayReservationDialog(context),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bar.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _showAvatar(),
            _showBarName(),
            _showBarContactInfo(),
            _horizontalDivider(),
            _showBarDescription(),
            _showReservationButton(context)
          ],
        ),
      ),
    );
  }
}