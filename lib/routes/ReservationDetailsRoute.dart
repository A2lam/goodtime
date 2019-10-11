import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodtime/models/GoodTime.dart';
import 'package:goodtime/services/ReservationService.dart';

class ReservationDetailsRoute extends StatefulWidget
{
  final GoodTime reservation;
  final ReservationService _reservationService = new ReservationService();

  ReservationDetailsRoute({ Key key, this.reservation }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ReservationDetailsRouteState();
}

class _ReservationDetailsRouteState extends State<ReservationDetailsRoute>
{
  /// Generates new horizontal divider
  Widget _horizontalDivider() => new Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: Divider(
        color: Colors.grey,
        height: 36,
      )
  );

  /// Displays the avatar
  Widget _showAvatar() => Container(
    padding: EdgeInsets.all(16),
    child: Hero(
      tag: widget.reservation.date.toString(),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage("https://media.timeout.com/images/105190023/380/285/image.jpg"),
      ),
    ),
  );

  /// Displays the bar's name
  Widget _showBarName() => Text(
    widget.reservation.bar.name,
    style: TextStyle(fontSize: 22),
  );

  /// Displays bar's phone number
  Widget _showBarPhoneNumber() => Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.phone),
        Text(
          widget.reservation.bar.phone,
          style: TextStyle(fontSize: 11.0),
        )
      ],
    ),
  );

  /// Displays reservation number of participants
  Widget _showReservationNumOfParticipants() => Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    child: Text(
      "Nombre de participant(s): " + widget.reservation.number_of_participants.toString(),
      style: TextStyle(fontSize: 16),
    ),
  );

  /// Displays reservation date
  Widget _showReservationDate() => Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    child: Text(
      "Date: " + widget.reservation.date.day.toString() + "/" + widget.reservation.date.month.toString() + "/" + widget.reservation.date.year.toString() + " " + widget.reservation.date.hour.toString() + ":" + widget.reservation.date.minute.toString(),
      style: TextStyle(fontSize: 16),
    ),
  );

  /// Displays reservation state
  Widget _showReservationState() {
    if (widget.reservation.status == "SOU") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("État : "),
          Text(
            "En attente",
            style: TextStyle(color: Colors.blueAccent),
          )
        ],
      );
    }

    else if (widget.reservation.status == "ACC") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("État : "),
          Text(
            "Confirmée",
            style: TextStyle(color: Colors.greenAccent),
          )
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("État : "),
            Text(
              "Refusée",
              style: TextStyle(color: Colors.redAccent),
            )
          ],
        ),
        Text("Motif du refus : " + widget.reservation.refusal_purpose)
      ],
    );
  }

  /// Cancel the details page
  _cancelDetails(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  /// Displays deletion successful message
  Future<Widget> _showSuccessfulMessage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Reservation annulé",
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

  /// Displays deletion error message
  Future<Widget> _showErrorDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Erreur lors de l'annulation",
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

  /// Deletes user account
  Future<void> _cancelReservation(BuildContext context, int reservationsId) async {
    bool reservationCanceled = await widget._reservationService.cancelReservation(reservationsId);
    if (reservationCanceled) {
      _showSuccessfulMessage(context);
    }
    else {
      _showErrorDialog(context);
    }
  }

  /// Displays cancel reservation button
  Widget _showRemoveFromFavoriteButton(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: FloatingActionButton.extended(
        heroTag: "cancelReservationBtn",
        backgroundColor: Colors.redAccent,
        icon: Icon(Icons.cancel),
        label: Text("Annuler la reservation"),
        onPressed: () => _cancelReservation(context, widget.reservation.id),
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la réservation"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _showAvatar(),
            _showBarName(),
            _showBarPhoneNumber(),
            _horizontalDivider(),
            _showReservationNumOfParticipants(),
            _showReservationDate(),
            _showReservationState(),
            _showRemoveFromFavoriteButton(context),
          ],
        ),
      ),
    );
  }
}