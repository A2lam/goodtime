import 'package:flutter/material.dart';

class Bar {
  final String id;
  final String name;
  final String description;
  final String address;

  const Bar({ @required this.id, @required this.name, @required this.description, @required this.address})
      : assert(id != null), assert(name != null), assert(description != null), assert(address != null);
}