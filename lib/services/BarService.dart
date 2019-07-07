import 'package:flutter/material.dart';
import 'package:goodtime/models/Bar.dart';

class BarService {
  Bar getById(id) {
    return new Bar(name: "Bar Exemple");
  }

  List<Bar> getAll() {
    List<Bar> barList = [];

    for (int i = 0; i < 15; i++) {
      barList.add(new Bar(name: "Bar " + i.toString()));
    }

    return barList;
  }
}