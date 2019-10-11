import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/models/GoodTime.dart';
import 'package:goodtime/services/ReservationService.dart';

class SingleReservationRoute extends StatefulWidget
{
  final Bar bar;
  final ReservationService _reservationService = new ReservationService();

  SingleReservationRoute({ Key key, this.bar }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SingleReservationRouteState();
}

class _SingleReservationRouteState extends State<SingleReservationRoute>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  int _numberOfParticipants;

  /// Cancel the details page
  _cancelDetails(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  /// Displays selected bar
  Widget _showSelectedBar() => Container(
    margin: EdgeInsets.only(top: 20.0),
    child: Center(
      child: Text(
        widget.bar.name,
        style: TextStyle(fontSize: 17.0),
      ),
    ),
  );

  /// Displays selected datetime
  Widget _showSelectedDatetime() => Container(
    margin: EdgeInsets.only(top: 20.0),
    child: Center(
      child: FlatButton.icon(
        onPressed: null,
        icon: Icon(Icons.calendar_today),
        label: Text(
          "Date : " + _date.day.toString() + "/" + _date.month.toString() + "/" + _date.year.toString() + " " +_date.hour.toString() + ":" + _date.minute.toString(),
          style: TextStyle(fontSize: 17.0),
        )
      ),
    ),
  );

  /// Displays Datetime picker dialog
  Widget _showDateTimePicker(BuildContext context) => Container(
    child: FlatButton(
      child: Text(
        'Séléctionner une date',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15.0,
        ),
      ),
      onPressed: () {
        DatePicker.showDateTimePicker(context,
          showTitleActions: true,
          onConfirm: (date) {
            print('confirm $date');
            setState(() {
              _date = date;
            });
          },
          currentTime: DateTime.now(), locale: LocaleType.fr
        );
      },
    ),
  );

  /// Displays number of participants input
  Widget _showNumberOfParticipantsInput() => new TextFormField(
    maxLines: 1,
    decoration: const InputDecoration(
      icon: const Icon(Icons.group_add),
      hintText: 'Renseignez le nombre de participant',
    ),
    validator: (value) => value.isEmpty ? 'Vous devez renseigner un nombre de participant' : null,
    onSaved: (value) => _numberOfParticipants = int.parse(value),
  );

  /// Displays successful creation message
  Future<Widget> _showSuccessfulMessage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Reservation effectuée",
              style: TextStyle(color: Colors.greenAccent),
            ),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => _cancelDetails(context),
                  child: Text('Ok')
              ),
            ],
          );
        }
    );
  }

  /// Displays error creation message
  Future<Widget> _showErrorDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Erreur lors de la réservation",
              style: TextStyle(color: Colors.redAccent),
            ),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok')
              ),
            ],
          );
        }
    );
  }

  /// Validates and submits the form
  void _validateAndSubmit(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      try {
        GoodTime goodTime = await widget._reservationService.createReservation(widget.bar.id, _date, _numberOfParticipants);

        if (null != goodTime) {
          _showSuccessfulMessage(context);
        }
        else {
          _showErrorDialog(context);
        }
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  /// Displays submit button
  Widget _showSubmitButton(BuildContext context) => Container(
    margin: EdgeInsets.only(top: 50.0, left: 65.0, right: 65.0),
    child: Center(
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)
        ),
        color: Colors.blueAccent,
        child: FlatButton.icon(
          onPressed: null,
          icon: Icon(Icons.save_alt, color: Colors.white),
          label: Text("Réserver", style: TextStyle(color: Colors.white))
        ),
        onPressed: () => _validateAndSubmit(context),
      ),
    ),
  );

  /// Displays the form
  Widget _showForm(BuildContext context) => Container(
    child: new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            _showNumberOfParticipantsInput(),
            _showSubmitButton(context),
          ],
        )
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Réservation personnelle"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _showSelectedBar(),
            _showSelectedDatetime(),
            _showDateTimePicker(context),
            _showForm(context)
          ],
        ),
      ),
    );
  }
}