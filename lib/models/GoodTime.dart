import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/models/Group.dart';

class GoodTime
{
  int id;
  Group group;
  Bar bar;
  DateTime date;
  bool is_booking;
  int number_of_participants;
  String status;
  String refusal_purpose;

  GoodTime({ this.id, this.group, this.bar, this.date, this.is_booking, this.number_of_participants, this.status, this.refusal_purpose });

  factory GoodTime.fromJson(Map<String, dynamic> json) {
    return GoodTime(
        id: json['id'],
        group: Group.fromJson(json['group']),
        bar: Bar.fromJson(json['bar']),
        date: json['phone'],
        is_booking: json['type'],
        number_of_participants: json['number_of_participants'],
        status: json['status'],
        refusal_purpose: json['refusal_purpose'],
    );
  }
}