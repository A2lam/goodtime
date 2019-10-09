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

  Group group;
  Bar bar;

  GoodTime({ this.id, this.groups_id, this.bars_id, this.date, this.is_booking, this.number_of_participants, this.status, this.refusal_purpose, this.group, this.bar });

  factory GoodTime.fromJson(Map<String, dynamic> json) {
    if (json["bar"] != null && json["group"] != null) {
      return GoodTime(
          id: json['id'],
          groups_id: json['groups_id'],
          bars_id: json['bars_id'],
          date: DateTime.parse(json['date']),
          is_booking: json['is_booking'] == 1 ? true : false,
          number_of_participants: json['number_of_participants'],
          status: json['status'],
          refusal_purpose: json['refusal_purpose'],
          group: Group.fromJson(json['group']),
          bar: Bar.fromJson(json['bar'])
      );
    }

    else if (json["bar"] != null && json["group"] == null) {
      return GoodTime(
          id: json['id'],
          groups_id: json['groups_id'],
          bars_id: json['bars_id'],
          date: DateTime.parse(json['date']),
          is_booking: json['is_booking'] == 1 ? true : false,
          number_of_participants: json['number_of_participants'],
          status: json['status'],
          refusal_purpose: json['refusal_purpose'],
          bar: Bar.fromJson(json['bar'])
      );
    }

    return GoodTime(
        id: json['id'],
        groups_id: json['groups_id'],
        bars_id: json['bars_id'],
        date: DateTime.parse(json['date']),
        is_booking: json['is_booking'] == 1 ? true : false,
        number_of_participants: json['number_of_participants'],
        status: json['status'],
        refusal_purpose: json['refusal_purpose'],
        group: null,
        bar: null
    );
  }
}