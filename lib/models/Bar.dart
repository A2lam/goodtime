import 'package:goodtime/models/Address.dart';
import 'package:goodtime/models/User.dart';

class Bar
{
  int id;
  String name;
  String description;
  String phone;
  String type;
  User user;
  Address address;

  Bar({ this.id, this.name, this.description, this.phone, this.type, this.user, this.address });

  factory Bar.fromJson(Map<String, dynamic> json) {
    if (json["user"] != null && json["address"] != null) {
      return Bar(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        phone: json['phone'],
        type: json['type'],
        user: User.fromJson(json['user']),
        address: Address.fromJson(json['address'])
      );
    }

    return Bar(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phone: json['phone'],
      type: json['type'],
    );
  }
}