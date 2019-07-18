import 'package:goodtime/models/Bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarService {
  CollectionReference _reference = Firestore.instance.collection('bars');

  Bar getById(id) {
    return new Bar(name: "Bar Exemple");
  }

  List<Bar> getAll() {
    List<Bar> barList = [];

    for (int i = 0; i < 15; i++) {
      // barList.add(new Bar(name: "Bar " + i.toString()));
      barList.add(new Bar(
          id: i.toString(),
          name: "Bar " + i.toString(),
          description: "Description " + i.toString(),
          address: "Adresse " + i.toString()
      ));
    }

    return barList;
  }

  Future<List<Bar>> getAllBarsFromFireStore() async {
    List<Bar> barList;
    _reference
        .snapshots()
        .listen((data) => data.documents.forEach((document) => barList.add(
        new Bar(
            id: document.documentID,
            name: document['name'],
            description: document['description'],
            address: document['address']
        )
    )));
    return barList;
  }
}