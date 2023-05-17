import 'package:firebase_core/firebase_core.dart';
import 'package:geofence/models/device.dart';
import 'package:geofence/models/globals.dart' as globals;
import 'package:geofence/models/notificationModel.dart';
import 'package:geofence/models/user.dart';
import 'package:logger/logger.dart';
import 'package:otp/otp.dart';
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

Future<List<User>> getAllChildren(String parentId) async {
  List<User> child = [];
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('parent_id', isEqualTo: parentId)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      child.add(User.fromJson(doc.data()));
    }
  });
  return child;
}

Future<void> getParentLocations(String parentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globals.parentLocations = [];
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseFirestore.instance
      .collection('locations')
      .where('userId', isEqualTo: parentId)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      globals.parentLocations.add(PlaceLocation.fromJson(doc.data()));
    }
  }).catchError((error) {});
  await prefs.setString('jsonParentLocations', encodeString());
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

Future<void> updateLocationOfUser(
    String id, double latitude, double longitude) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .update({'latitude': latitude, 'longitude': longitude})
      .then((value) => print("User location updated successfully"))
      .catchError((error) => print("Failed to update user location: $error"));
}

Future<void> updateUserLocationId(String id, String locationId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .update({'location_id': locationId})
      .then((value) => print("User location updated successfully"))
      .catchError((error) => print("Failed to update user location: $error"));
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

Future<User?> getUserDetails(String id) async {
  User? curUser = null;
  await FirebaseFirestore.instance
      .collection('users')
      .where("id", isEqualTo: id)
      .get()
      .then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      curUser = User.fromJson(doc.data());
    }
  });

  return curUser;
}

Future<bool> login(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await getUsers();
  for (int i = 0; i < globals.users.length; i++) {
    if (globals.users[i].name == username &&
        globals.users[i].password == password) {
      globals.currentUser = globals.users[i];
      globals.token = globals.users[i].name;
      globals.currentUser = globals.users[i];
      await prefs.setString('token', globals.currentUser.name);
      await prefs.setString('userid', globals.currentUser.id);
      await prefs.setString('parentid', globals.currentUser.parent_id);
      getLocationByUser(globals.currentUser.id);

      return true;
    }
  }
  return false;
}

String encodeString() {
  String jsonString;
  Map<String, dynamic> myMap = {
    'latitude': [],
    'longitude': [],
    'radius': [],
    'id': [],
    'name': []
  };
  for (var loc in globals.locations) {
    double latitude = loc.latitude;
    double longitude = loc.longitude;

    myMap['latitude'].add(loc.latitude);
    myMap['longitude'].add(loc.longitude);
    myMap['radius'].add(loc.radius);
    myMap['id'].add(loc.id);
    myMap['name'].add(loc.name);
  }
  return json.encode(myMap);
}

Future<bool> register(User user) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('users')
      .where('name', isEqualTo: user.name)
      .get();
  if (snapshot.size == 0) {
    final docDevices = FirebaseFirestore.instance.collection('users').doc();
    user.id = docDevices.id;
    final json = user.toJson();
    try {
      await docDevices.set(json);
      globals.currentUser = user;
    } catch (e) {
      return false;
    }
  } else {
    print('Token already exists in database');
  }
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final docNotification =
      FirebaseFirestore.instance.collection('notification').doc();
  noti.id = docNotification.id;
  final json = noti.toJson();
  await docNotification.set(json).then((value) async {});
}

Future<void> getUserDeviceList(String id) async {
  globals.userDevices = [];
  await FirebaseFirestore.instance
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
      .where('user_id', isEqualTo: device.user_id)
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

Future<void> deleteUserDevice(String id) async {
  String deviceId = id;
  final doc = FirebaseFirestore.instance
      .collection('devices')
      .where("id", isEqualTo: deviceId)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }).catchError((error) {});
}

Future<void> sendOTPCode(String name) async {
  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('users')
      .where('name', isEqualTo: name)
      .get();

  if (snapshot.size != 0) {
    final String documentId = snapshot.docs[0].id;
    final code = OTP.generateTOTPCodeString(
        documentId, DateTime.now().millisecondsSinceEpoch);
    globals.otpCode = code;
    globals.sentId = documentId;
    await FirebaseFirestore.instance.collection("UserOtp").doc(documentId).set({
      'otp': code,
    });
  } else {
    print('Token already exists in database');
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
