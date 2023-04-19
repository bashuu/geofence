// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofence/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/reference.dart';
import '../models/database.dart';

class PeopleMap extends StatefulWidget {
  const PeopleMap({super.key});

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

  DB db = DB();
  late Marker marker;
  late Circle circle;

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(47.904138, 106.915224),
    zoom: 14.4746,
  );

  //small test
  Future<void> init() async {
    await db.getLocations();
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
          getCurrentLocation();
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
