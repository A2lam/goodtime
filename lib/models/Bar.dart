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

  Bar({ this.id, this.name, this.phone, this.type, this.user, this.address });

  factory Bar.fromJson(Map<String, dynamic> json) {
    return Bar(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      user: User.fromJson(json['user']),
      address: Address.fromJson(json['address'])
    );
  }
}