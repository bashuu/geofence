// ignore: file_names
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geofence/models/globals.dart' as globals;

import '../models/place.dart';
import '../models/database.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => CchooseLocationState();
}

class CchooseLocationState extends State<AddLocation> {
  TextEditingController locationNameController = TextEditingController();
  TextEditingController locationAddressController = TextEditingController();
  PanelController panelController = PanelController();
  late GoogleMapController _controller;

  final String _selectText = "Байршил сонгох";
  List<String> chipSelect = ["150 M", "500 M", "1 km", "2km", "5km"];
  int? _value = 0;
  double _radius = 150;
  bool _showWarning = false;

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(47.904138, 106.915224),
    zoom: 14.5,
  );

  LatLng? _center;

  Marker? _marker;

  Circle? _circle;

  Future createLocation() async {
    if (locationNameController.text.isEmpty) {
      setState(() {
        _showWarning = true;
      });
    }
    _showWarning = false;
    PlaceLocation newLocation = PlaceLocation(
        name: locationNameController.text,
        latitude: _center!.latitude,
        longitude: _center!.longitude,
        radius: _radius,
        address: locationAddressController.text,
        userId: globals.currentUser.id,
        id: "0",
        create_date: DateTime.now(),
        update_date: DateTime.now());

    await addLocations(newLocation);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
      _marker = Marker(
        markerId: const MarkerId('center_marker'),
        position: _center!,
      );
      _circle = Circle(
        circleId: const CircleId('center_circle'),
        center: _center!,
        radius: _radius,
        fillColor: Colors.blue.withOpacity(0.1),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );
    });
  }

  void _updateCameraPosition(LatLng latLng, double zoom) {
    CameraPosition newPosition = CameraPosition(target: latLng, zoom: zoom);
    _controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  void initState() {
    _center = kGooglePlex.target;
    _marker = Marker(
      markerId: const MarkerId('center_marker'),
      position: _center!,
    );
    _circle = Circle(
      circleId: const CircleId('center_circle'),
      center: _center!,
      radius: _radius,
      fillColor: Colors.blue.withOpacity(0.1),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        // if (isPanelOpen) {
        //   panelController.close();
        //   isPanelOpen = !isPanelOpen;
        // }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            toolbarHeight: 50.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.darkerWhite,
            leading: IconButton(
              color: Colors.ligthBlack,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Байршил",
              style: TextStyle(
                color: Colors.ligthBlack,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.brightOrange),
                color: Colors.black,
                onPressed: () async {
                  try {
                    await createLocation().then((value) {
                      Navigator.pushNamed(context, '/homePage');
                    });
                    // ignore: empty_catches
                  } catch (e) {}
                },
              ),
            ],
          ),
        ),
        body: SlidingUpPanel(
          panel: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 55,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.darkerWhite,
                      border: Border.all(
                        color: Colors.darkerWhite,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextField(
                    controller: locationAddressController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      hintText: 'Байршлын нэр',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          controller: panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.darkerWhite,
                      border: Border.all(
                        color: Colors.darkerWhite,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextField(
                    controller: locationNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Байршлын нэр',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_showWarning)
                const Text(
                  'Text is required',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.darkerWhite,
                      border: Border.all(
                        color: Colors.darkerWhite,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextField(
                    controller: locationAddressController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Байршлын хаяг',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_showWarning)
                const Text(
                  'Text is required',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.darkerWhite,
                  border: Border.all(
                    color: Colors.darkerWhite,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Center(
                  child: Wrap(
                    spacing: 5.0,
                    children: List<Widget>.generate(
                      chipSelect.length,
                      (int index) {
                        return ChoiceChip(
                          selectedColor: Colors.brightOrange,
                          shadowColor: Colors.darkerWhite,
                          backgroundColor: Colors.darkerWhite,
                          label: Text(chipSelect[index]),
                          selected: _value == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _value = selected ? index : null;
                              switch (index) {
                                case 0:
                                  _radius = 150;
                                  _updateCameraPosition(_center!, 15.85);

                                  break;
                                case 1:
                                  _radius = 500;
                                  _updateCameraPosition(_center!, 14.5);

                                  break;
                                case 2:
                                  _radius = 1000;
                                  _updateCameraPosition(_center!, 14);

                                  break;
                                case 3:
                                  _radius = 2000;
                                  _updateCameraPosition(_center!, 12.5);

                                  break;

                                case 4:
                                  _radius = 5000;
                                  _updateCameraPosition(_center!, 11.5);

                                  break;
                              }
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.darkerWhite,
                  border: Border.all(
                    color: Colors.darkerWhite,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: GoogleMap(
                  mapType: MapType.normal,
                  onCameraMove: _onCameraMove,
                  initialCameraPosition: kGooglePlex,
                  // ignore: prefer_collection_literals
                  markers: _marker != null ? Set.of([_marker!]) : Set(),
                  // ignore: prefer_collection_literals
                  circles: _circle != null ? Set.of([_circle!]) : Set(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
