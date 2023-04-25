// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence/models/place.dart';
import 'package:geofence/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../models/reference.dart';
import '../models/database.dart';
import '../places/notification.dart' as notif;
import 'dart:math';

const fetchBackground = "fetchBackground";
late List<PlaceLocation> currentListLoc;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Logger().i("inputdata" + inputData.toString());

    switch (task) {
      case fetchBackground:
        Position userLocation = await Geolocator.getCurrentPosition();

        if (inputData == null) break;
        String json = inputData!['json'];
        Map<String, dynamic> jsonMap = jsonDecode(json);
        List<dynamic> longitudeList = jsonMap['longitude'];
        List<dynamic> latitudeList = jsonMap['latitude'];
        List<dynamic> rads = jsonMap['radius'];

        for (int i = 0; i < longitudeList.length; i++) {
          // Logger().i("userLocation" + Location!.toString());
          if (isUserInLocation(
              latitudeList[i],
              longitudeList[i],
              userLocation.latitude ?? 0,
              userLocation.longitude ?? 0,
              rads[i])) {
            Logger().i("It's in");
            return true;
          }
        }
        notif.Notification notification =
            notif.Notification(flutterLocalNotificationsPlugin);
        notification.flutterLocalNotificationsPlugin =
            flutterLocalNotificationsPlugin;
        notification.showNotificationWithoutSound(userLocation);
        break;
    }
    return Future.value(true);
  });
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
  static const fetchBackground = "fetchBackground";
  @override
  State<PeopleMap> createState() => _PeopleMapState();
}

class _PeopleMapState extends State<PeopleMap> {
  late GoogleMapController _controller;
  // late StreamSubscription _locationSub;
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
    await getLocations();

    setState(() {
      isLoading = false;
    });
    initLocations();

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

  void initLocations() {
    for (var element in locations) {
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

  void getCurrentLocation() async {
    try {
      // Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      Logger().i("location$location");
      updateMarkerAndCircle(location);

      final locData = await Location().getLocation();
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(locData.latitude ?? 0, locData.longitude ?? 0),
          tilt: 0,
          zoom: 18.00)));

      // _locationSub = _locationTracker.onLocationChanged
      //     .listen((LocationData newLocalData) {
      //   if (_controller != null) {
      //     _controller.animateCamera(CameraUpdate.newCameraPosition(
      //         CameraPosition(
      //             bearing: 192.8334901395799,
      //             target: LatLng(
      //                 newLocalData.latitude ?? 0, newLocalData.longitude ?? 0),
      //             tilt: 0,
      //             zoom: 18.00)));
      //     updateMarkerAndCircle(newLocalData);
      //   }
      // });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    checkForGeofence();
  }

  void checkForGeofence() {
    String jsonString;
    Map<String, dynamic> myMap = {
      'latitude': [],
      'longitude': [],
      'radius': []
    };
    for (var loc in locations) {
      double latitude = loc.latitude;
      double longitude = loc.longitude;

      myMap['latitude'].add(loc.latitude);
      myMap['longitude'].add(loc.longitude);
      myMap['radius'].add(loc.radius);
    }
    jsonString = json.encode(myMap);
    Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: Duration(minutes: 1),
      inputData: {'json': jsonString},
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
          Workmanager().registerOneOffTask(
            "2",
            fetchBackground,
          );
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
