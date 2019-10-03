import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';

/*class BarDetailsRoute extends StatelessWidget
{
  final Bar bar;
  String _numberOfPerson;
  String _reservationDate;

  TextEditingController _numberOfPersonTextFieldController = TextEditingController();
  TextEditingController _reservationDateTextFieldController = TextEditingController();

  BarDetailsRoute({Key key, this.bar}) : super(key: key);

  Widget _showNumberOfPersonInput () {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Nombre de personne',
            icon: Icon(
              Icons.restaurant_menu,
              color: Colors.grey,
            )
        ),
        validator: (value) => value.isEmpty ? 'Vous devez renseigner ce champ' : null,
        onSaved: (value) => _numberOfPerson = value,
      ),
    );
  }

  Widget _showReservationDateInput () {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Date de la reservation',
            icon: Icon(
              Icons.date_range,
              color: Colors.grey,
            )
        ),
        validator: (value) => value.isEmpty ? 'Vous devez renseigner ce champ' : null,
        onSaved: (value) => _reservationDate = value,
      ),
    );
  }

  Future<Widget> _displayReservationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Réservation'),
          content: /*TextField(
            controller: _numberOfPersonTextFieldController,
            decoration: InputDecoration(hintText: "TextField in Dialog"),
          )*/ Column(
            children: <Widget>[
              _showNumberOfPersonInput(),
              _showReservationDateInput()
              /*TextField(
                controller: _numberOfPersonTextFieldController,
                decoration: InputDecoration(hintText: "Nombre de personne"),
              ),
              TextField(
                controller: _reservationDateTextFieldController,
                decoration: InputDecoration(hintText: "Date de reservation"),
              )*/
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Réserver'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget topContentText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        SizedBox(height: 10.0),
        Center(
          child: Text(
            bar.name,
            style: TextStyle(color: Colors.white, fontSize: 45.0),
          ),
        ),
        Center(
          child: Text(
            bar.address.street,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget topContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              color: Colors.amber[200]
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.amber[200]), // Color.fromRGBO(58, 66, 86, .9)
          child: Center(
            child: topContentText(),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget bottomContentText() {
    return Text(
      bar.name,
      style: TextStyle(fontSize: 18.0),
    );
  }

  Widget bookButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () =>  _displayReservationDialog(context),
          color: Colors.amber[200], // Color.fromRGBO(58, 66, 86, 1.0)
          child:
          Text("Réserver", style: TextStyle(color: Colors.white)),
        ));
  }

  Widget bottomContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText(),
            bookButton(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          topContent(context),
          bottomContent(context)
        ],
      ),
    );
  }
}*/

class BarDetailsRoute extends StatelessWidget
{
  final Bar bar;

  BarDetailsRoute({ Key key, this.bar }) : super(key: key);

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
      tag: bar.name,
      child: CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage("https://media.timeout.com/images/105190023/380/285/image.jpg"),
      ),
    ),
  );

  /// Displays the bar's name
  Widget _showBarName() => Text(
    bar.name,
    style: TextStyle(fontSize: 22),
  );

  /// Displays bar's address
  Widget _showBarAddress() => Row(
    children: <Widget>[
      Icon(Icons.location_on),
      Text(
        bar.address.number.toString() + " " + bar.address.street + ", " + bar.address.post_code.toString() + " " + bar.address.city,
        style: TextStyle(fontSize: 11.0),
      )
    ],
  );

  /// Displays bar's phone number
  Widget _showBarPhoneNumber() => Row(
    children: <Widget>[
      Icon(Icons.phone),
      Text(
        bar.phone,
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
      bar.description,
      style: TextStyle(fontSize: 16),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bar.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _showAvatar(),
            _showBarName(),
            _showBarContactInfo(),
            _horizontalDivider(),
            _showBarDescription(),
          ],
        ),
      ),
    );
  }
}