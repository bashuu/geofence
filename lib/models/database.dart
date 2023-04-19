import 'package:geofence/models/reference.dart';

import 'place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DB {
  DB();

  Future<void> getLocations() async {
    locations = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        locations.add(PlaceLocation.fromJson(doc.data()));
      }
    }).catchError((error) {});
  }

  Future<void> addLocations(PlaceLocation location) async {
    final docLocation =
        FirebaseFirestore.instance.collection('locations').doc();
    location.id = docLocation.id;
    final json = location.toJson();
    await docLocation.set(json).then((value) async {
      getLocations();
    });
  }

  Future<void> deleteLocation(PlaceLocation doc) async {
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(doc.id)
        .delete()
        .then((value) {})
        .catchError((error) {});
  }
}
