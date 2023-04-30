// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence/models/notificationModel.dart';
import 'package:geofence/models/place.dart';
import 'package:geofence/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/globals.dart' as globals;
import '../models/database.dart';
import '../places/notification.dart' as notif;
import 'dart:math';
import 'package:http/http.dart' as http;

const fetchBackground = "fetchBackground";
late List<PlaceLocation> currentListLoc;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    switch (task) {
      case fetchBackground:
        if (await checkLocations()) {
          return Future.value(true);
        }
        if (await checkParentLocations()) {
          return Future.value(true);
        }

        break;
    }
    return Future.value(true);
  });
}

Future<bool> checkLocations() async {
  String userId = await getCredentials();
  String jsonString = await getJsonLocation();
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  updateUserLocationId(userId, "Set");

  Position userLocation = await Geolocator.getCurrentPosition();
  List<dynamic> longitudeList = jsonMap['longitude'];
  List<dynamic> latitudeList = jsonMap['latitude'];
  List<dynamic> rads = jsonMap['radius'];
  List<dynamic> locId = jsonMap['id'];
  Logger().e(longitudeList.length);

  await getLocationByUser(userId);
  for (int i = 0; i < longitudeList.length; i++) {
    if (isUserInLocation(latitudeList[i], longitudeList[i],
        userLocation.latitude ?? 0, userLocation.longitude ?? 0, rads[i])) {
      await updateUserLocationId(userId, locId[i]);
      await sendGroupPushMessage(locId[i], "The user is in a geofence",
              "This is a background process")
          .then((value) {
        return true;
      });
    }
  }
  await updateUserLocationId(userId, "");
  return false;
}

Future<bool> checkParentLocations() async {
  String userId = await getCredentials();
  String jsonString = await getJsonParentLocation();
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  Position userLocation = await Geolocator.getCurrentPosition();
  List<dynamic> longitudeList = jsonMap['longitude'];
  List<dynamic> latitudeList = jsonMap['latitude'];
  List<dynamic> rads = jsonMap['radius'];
  List<dynamic> locId = jsonMap['id'];
  Logger().e(longitudeList.length);

  await getLocationByUser(userId);
  for (int i = 0; i < longitudeList.length; i++) {
    if (isUserInLocation(latitudeList[i], longitudeList[i],
        userLocation.latitude ?? 0, userLocation.longitude ?? 0, rads[i])) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await updateUserLocationId(userId, locId[i]);
      NotificationModel newNoti = NotificationModel(
          title: "The user is in a geofence",
          body: "This is a background process",
          time: DateTime.now(),
          user_id: userId,
          id: "0");

      await addUserNotification(newNoti);
      await sendGroupPushMessage(locId[i], "The user is in a geofence",
              "This is a background process")
          .then((value) {
        return true;
      });
    }
  }
  await updateUserLocationId(userId, "");
  return false;
}

Future<void> sendGroupPushMessage(
    String token, String title, String body) async {
  Logger().i("Send Noti");
  Logger().e(token);

  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA6nApToE:APA91bGgoSB0zwS8kUhtHTEpT5-kNHVz2ZWqAExFAVU49ykuXjob1BqqgarFrJ-ZetrWK8NSZaAvYVM0AtajFo3XaZ9eELkm165SGTesOfg0fB6gFp8VxzVKnbkbohV777HsP0jeEoAB',
  };
  final bodyJson = {
    'to': "/topics/$token",
    'priority': 'high',
    'notification': {
      'title': title,
      'body': body,
      "android_channel_id": "geofenceChannnel"
    },
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'sound': 'default',
      'status': 'done',
      'title': title,
      'body': body,
    },
  };

  try {
    await http
        .post(url, headers: headers, body: json.encode(bodyJson))
        .then((value) {});
  } catch (e) {
    Logger().e(e);
  }
}

Future<String> getParentCred() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String parentid = prefs.getString('parentid') ?? '';
  return parentid;
}

Future<String> getCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userid = prefs.getString('userid') ?? '';
  return userid;
}

Future<String> getJsonLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userid = prefs.getString('jsonLocation') ?? '';
  return userid;
}

Future<String> getJsonParentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userid = prefs.getString('jsonParentLocations') ?? '';
  return userid;
}

bool isUserInLocation(
    double lat1, double lon1, double lat2, double lon2, double radius) {
  double earthRadius = 6378137; // radius of the earth in meters
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c; // distance in meters
  Logger().i(distance);
  return distance <= radius;
}

double _toRadians(double degrees) {
  return degrees * pi / 180;
}

class PeopleMap extends StatefulWidget {
  const PeopleMap({super.key});
  @override
  State<PeopleMap> createState() => _PeopleMapState();
}

class _PeopleMapState extends State<PeopleMap> {
  late GoogleMapController _controller;
  late StreamSubscription _locationSub;
  final Location _locationTracker = Location();
  bool isLoading = true;
  List<User> users = [];
  List<Marker> markerList = [];
  List<Circle> circleList = [];

  late Marker marker;
  late Circle circle;

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(47.904138, 106.915224),
    zoom: 14.4746,
  );

  //small test
  Future<void> init() async {
    String userId = await getCredentials();
    String jsonString = await getJsonLocation();
    String parentId = await getParentCred();

    await getLocationByUser(userId).then((value) {
      // Logger().e(jsonString);
      initLocations();
    });

    await getParentLocations(parentId).then((value) {
      initParentLocations();
    });
    setState(() {
      isLoading = false;
    });

    marker = const Marker(
      markerId: MarkerId("Home"),
      position: LatLng(0, 0),
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
    );
    circle = const Circle(
      circleId: CircleId("car"),
      zIndex: 1,
      strokeColor: Colors.brightOrange,
    );
  }

  void initParentLocations() {
    for (var element in globals.parentLocations) {
      FirebaseMessaging.instance.subscribeToTopic(element.id);

      markerList.add(
        Marker(
          markerId: MarkerId("Location${element.id}"),
          position: LatLng(element.latitude, element.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
      circleList.add(
        Circle(
            circleId: CircleId(element.id.toString()),
            radius: element.radius,
            zIndex: 1,
            strokeColor: Colors.brightOrange,
            center: LatLng(element.latitude, element.longitude),
            strokeWidth: 2),
      );
    }
  }

  void initLocations() {
    for (var element in globals.locations) {
      FirebaseMessaging.instance.subscribeToTopic(element.id);

      markerList.add(
        Marker(
          markerId: MarkerId("Location${element.id}"),
          position: LatLng(element.latitude, element.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
      circleList.add(
        Circle(
            circleId: CircleId(element.id.toString()),
            radius: element.radius,
            zIndex: 1,
            strokeColor: Colors.brightOrange,
            center: LatLng(element.latitude, element.longitude),
            strokeWidth: 2),
      );
    }

    for (var element in users) {
      markerList.add(
        Marker(
          markerId: MarkerId("User${element.id}"),
          position: LatLng(element.latitude, element.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/map_circular_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData? newLocalData) {
    LatLng latLng;
    latLng = LatLng(newLocalData?.latitude ?? 0, newLocalData?.longitude ?? 0);

    setState(() {
      marker = Marker(
        markerId: const MarkerId("Home"),
        position: latLng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
      );
      circle = Circle(
        circleId: const CircleId("car"),
        radius: 100,
        zIndex: 1,
        strokeColor: Colors.brightOrange,
        center: latLng,
      );
    });
  }

  @override
  void initState() {
    setState(() {
      markerList = [];
      circleList = [];
    });
    init();
    super.initState();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    checkForGeofence();
  }

  void checkForGeofence() async {
    Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  @override
  void dispose() {
    // if (_locationSub != null) {
    //   _locationSub.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          toolbarHeight: 50.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.darkerWhite,
          title: const Text(
            "Хүмүүс",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.ligthBlack),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, "/notificationList");
              },
            ),
          ],
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        // ignore: unnecessary_null_comparison
        markers: Set.of((markerList != null) ? markerList : []),
        // ignore: unnecessary_null_comparison
        circles: Set.of((markerList != null) ? circleList : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // sendGroupPushMessage("RV9GmNueIPaOTtjMaZ8o", "Group test", "hello");
          // updateUserLocationId(globals.currentUser.id, "Hiu");

          Workmanager().registerOneOffTask(
            "2",
            fetchBackground,
            constraints: Constraints(
              networkType: NetworkType.connected,
            ),
          );
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
