import 'package:geofence/models/reference.dart';
import 'package:geofence/models/user.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

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

Future<void> addLocations(PlaceLocation newLocation) async {
  final docLocation = FirebaseFirestore.instance.collection('locations').doc();
  newLocation.id = docLocation.id;
  final json = newLocation.toJson();
  await docLocation.set(json).then((value) async {
    addUserLocation(newLocation);
    getLocations();
  });
}

Future<void> deleteLocation(PlaceLocation doc) async {
  await FirebaseFirestore.instance
      .collection('locations')
      .doc(doc.id)
      .delete()
      .then((value) {
    deleteUserLocation(doc);
  }).catchError((error) {});
}

Future<void> getUsers() async {
  await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      users.add(User.fromJson(doc.data()));
    }
  }).catchError((error) {});
}

Future<void> getUserDetails(String id) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  if (snapshot.exists) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  }
}

Future<bool> login(String username, String password) async {
  getUsers();
  for (int i = 0; i < users.length; i++) {
    if (users[i].name == username && users[i].password == password) {
      currentUser = users[i];
      token = users[i].name;
      return true;
    }
  }
  return false;
}

Future<bool> register(User user) async {
  getUsers();
  for (int i = 0; i < users.length; i++) {
    if (user.name == user.name) {
      return false;
    }
  }
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id = docUser.id;
  final json = user.toJson();
  if (user.parent_id == "0") {
    user.parent_id == user.id;
  } else {
    user.parent_id = currentUser.id;
  }
  await docUser.set(json).then((value) async {
    getUsers();
  });
  return true;
}

Future<void> addUserLocation(PlaceLocation newLocation) async {
  final doc = FirebaseFirestore.instance.collection('user_location').doc();
  String id = doc.id;
  String user_id = currentUser.id;
  String location_id = newLocation.id;
  var data = {
    "id": doc.id,
    "user_id": user_id,
    "location_id": location_id,
  };
  doc.set(data);
}

Future<void> deleteUserLocation(PlaceLocation newLocation) async {
  String locationId = newLocation.id;
  final doc = FirebaseFirestore.instance
      .collection('user_location')
      .where("location_id", isEqualTo: locationId)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
      print('Document with location_id $locationId deleted successfully.');
    });
  }).catchError((error) {
    print('Error deleting document: $error');
  });
}

Future<void> getAllLocationUsers(PlaceLocation curLocation) async {
  List<String> userIds = [];
  final QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
      .collection('user_location')
      .where('location_id', isEqualTo: curLocation.id)
      .get();
  for (QueryDocumentSnapshot doc in locationSnapshot.docs) {
    String userId = await doc.get('user_id');

    if (userId != null) {
      userIds.add(userId);
    }
  }

  for (String userId in userIds) {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      User us = User.fromJson(userData);
      locationUser.add(us);
    }
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
