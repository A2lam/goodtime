import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:goodtime/models/Bar.dart';

class SingleReservationRoute extends StatefulWidget
{
  final Bar bar;

  SingleReservationRoute({ Key key, this.bar }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SingleReservationRouteState();
}

class _SingleReservationRouteState extends State<SingleReservationRoute>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  int _numberOfParticipants;
  String _errorMessage;
  bool _isLoading;
  bool _isIos;

  /// Initialization
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

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

  /// Displays error message
  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Center(
        child: Text(
          _errorMessage,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300
          ),
        ),
      );
    }
    else {
      return new Container(
        height: 0.0,
      );
    }
  }

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

  /// Validates and submits the form
  void _validateAndSubmit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      try {
        // Call to the API

        if (true) {

        }
        else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Erreur lors de la réservation !";
          });
        }
      }
      catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          }
          else {
            _errorMessage = e.message;
          }
        });
      }
    }
  }

  /// Displays submit button
  Widget _showSubmitButton() => Container(
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
        onPressed: () => _validateAndSubmit(),
      ),
    ),
  );

  /// Displays the form
  Widget _showForm() => Container(
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
            _showSubmitButton(),
            _showErrorMessage(),
          ],
        )
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text("Réservation personnelle"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _showSelectedDatetime(),
            _showDateTimePicker(context),
            _showForm()
          ],
        ),
      ),
    );
  }
}