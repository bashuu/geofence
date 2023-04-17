import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofence/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/place.dart';
import '../models/user.dart';

class PeopleMap extends StatefulWidget {
  const PeopleMap({super.key});

  @override
  State<PeopleMap> createState() => _PeopleMapState();
}

class _PeopleMapState extends State<PeopleMap> {
  late GoogleMapController _controller;
  // late StreamSubscription _locationSub;
  Location _locationTracker = Location();

  List<PlaceLocation> locations = [];

  List<User> users = [];
  List<Marker> markerList = [];
  List<Circle> circleList = [];

  late Marker marker;
  late Circle circle;

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(47.904138, 106.915224),
    zoom: 14.4746,
  );

  Future<void> init() async {
    await getLocations().then((value) => {initLocations()});

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

  Future<void> getLocations() async {
    locations = [];
    await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        locations.add(PlaceLocation.fromJson(doc.data()));
      });
    });
    initLocations();
  }

  void initLocations() {
    locations.forEach((element) {
      markerList.add(
        Marker(
          markerId: MarkerId("Location${element.id}"),
          position: LatLng(element.latitude, element.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
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
    });

    users.forEach((element) {
      markerList.add(
        Marker(
          markerId: MarkerId("User${element.id}"),
          position: LatLng(element.latitude, element.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
        ),
      );
    });
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
        markerId: MarkerId("Home"),
        position: latLng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
      );
      circle = Circle(
        circleId: CircleId("car"),
        radius: 100,
        zIndex: 1,
        strokeColor: Colors.brightOrange,
        center: latLng,
      );
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

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
    getCurrentLocation();
    super.initState();
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
        preferredSize: Size.fromHeight(50.0),
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
        markers: Set.of((markerList != null) ? markerList : []),
        circles: Set.of((markerList != null) ? circleList : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
