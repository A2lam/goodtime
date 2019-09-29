import 'package:goodtime/models/Address.dart';
import 'package:goodtime/models/User.dart';

class Bar
{
  int id;
  String name;
  String phone;
  String type;
  User user;
  Address address;
  int created_by;
  DateTime created_at;
  int updated_by;
  DateTime updated_at;
  bool is_active;

  Bar({ this.id, this.name, this.phone, this.type, this.user, this.address, this.created_by, this.created_at, this.updated_by, this.updated_at, this.is_active });

  factory Bar.fromJson(Map<String, dynamic> json) {
    return Bar(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      user: User.fromJson(json['user']),
      address: Address.fromJson(json['address']),
      created_by: json['created_by'],
      created_at: json['created_at'],
      updated_by: json['updated_by'],
      updated_at: json['updated_at'],
      is_active: json['is_active'],
    );
  }
}