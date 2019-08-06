import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';

class BarDetailsRoute extends StatelessWidget {
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

  _displayReservationDialog(BuildContext context) async {
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
        });
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
            bar.address,
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
      bar.description,
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
}