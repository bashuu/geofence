import 'package:firebase_core/firebase_core.dart';
import 'package:geofence/models/device.dart';
import 'package:geofence/models/globals.dart' as globals;
import 'package:geofence/models/notificationModel.dart';
import 'package:geofence/models/user.dart';
import 'dart:convert';
import '../firebase_options.dart';
import 'place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getLocations() async {
  var locations = [];
  await FirebaseFirestore.instance
      .collection('locations')
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      locations.add(PlaceLocation.fromJson(doc.data()));
    }
  }).catchError((error) {});
}

Future<void> getLocationByUser(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globals.locations = [];
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance
      .collection('locations')
      .where('userId', isEqualTo: id)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      globals.locations.add(PlaceLocation.fromJson(doc.data()));
    }
  }).catchError((error) {});
  await prefs.setString('jsonLocation', encodeString());
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
      globals.users.add(User.fromJson(doc.data()));
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  getUsers();
  for (int i = 0; i < globals.users.length; i++) {
    if (globals.users[i].name == username &&
        globals.users[i].password == password) {
      globals.currentUser = globals.users[i];
      globals.token = globals.users[i].name;
      await prefs.setString('token', globals.currentUser.name);
      await prefs.setString('userid', globals.currentUser.id);
      getLocationByUser(globals.currentUser.id);

      return true;
    }
  }
  return false;
}

String encodeString() {
  String jsonString;
  Map<String, dynamic> myMap = {'latitude': [], 'longitude': [], 'radius': []};
  for (var loc in globals.locations) {
    double latitude = loc.latitude;
    double longitude = loc.longitude;

    myMap['latitude'].add(loc.latitude);
    myMap['longitude'].add(loc.longitude);
    myMap['radius'].add(loc.radius);
  }
  return json.encode(myMap);
}

Future<bool> register(User user) async {
  getUsers();
  for (int i = 0; i < globals.users.length; i++) {
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
    user.parent_id = globals.currentUser.id;
  }
  await docUser.set(json).then((value) async {
    getUsers();
  });
  return true;
}

Future<void> addUserLocation(PlaceLocation newLocation) async {
  final doc = FirebaseFirestore.instance.collection('user_location').doc();
  String id = doc.id;
  String user_id = globals.currentUser.id;
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
  globals.locationUser = [];
  for (String userId in userIds) {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      User us = User.fromJson(userData);
      globals.locationUser.add(us);
    }
  }
}

Future<void> getUserNotification(String id) async {
  final doc = FirebaseFirestore.instance
      .collection('notification')
      .where("user_id", isEqualTo: id)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      globals.userNotifications.add(NotificationModel.fromJson(doc.data()));
    }
  });
}

Future<void> addUserNotification(NotificationModel noti) async {
  final docNotification =
      FirebaseFirestore.instance.collection('notification').doc();
  noti.id = docNotification.id;
  final json = noti.toJson();
  await docNotification.set(json).then((value) async {});
}

Future<void> getUserDeviceList(String id) async {
  final doc = FirebaseFirestore.instance
      .collection('devices')
      .where("user_id", isEqualTo: id)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      globals.userDevices.add(DeviceModel.fromJson(doc.data()));
    }
  });
}

Future<void> addUserDevice(DeviceModel device) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('devices')
      .where('token', isEqualTo: device.token)
      .get();
  if (snapshot.size == 0) {
    final docDevices = FirebaseFirestore.instance.collection('devices').doc();
    device.id = docDevices.id;
    final json = device.toJson();
    await docDevices.set(json);
  } else {
    print('Token already exists in database');
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
