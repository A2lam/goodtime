import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/models/Group.dart';

class GoodTime
{
  int id;
  int groups_id;
  int bars_id;
  DateTime date;
  bool is_booking;
  int number_of_participants;
  String status;
  String refusal_purpose;

  GoodTime({ this.id, this.groups_id, this.bars_id, this.date, this.is_booking, this.number_of_participants, this.status, this.refusal_purpose });

  factory GoodTime.fromJson(Map<String, dynamic> json) {
    return GoodTime(
        id: json['id'],
        groups_id: json['groups_id'],
        bars_id: json['bars_id'],
        date: json['phone'],
        is_booking: json['type'],
        number_of_participants: json['number_of_participants'],
        status: json['status'],
        refusal_purpose: json['refusal_purpose'],
    );
  }
}