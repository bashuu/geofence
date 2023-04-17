import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/popUpModal.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({super.key});

  @override
  State<GeoLocation> createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  List<PlaceLocation> locations = [
    PlaceLocation(
        name: 'Location 1',
        latitude: 37.4219999,
        longitude: -122.0840575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "1"),
    PlaceLocation(
        name: 'Location 2',
        latitude: 37.4221999,
        longitude: -122.0842575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "2"),
    PlaceLocation(
        name: 'Location 3',
        latitude: 37.4222999,
        longitude: -122.0843575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "3"),
    PlaceLocation(
        name: 'Location 4',
        latitude: 37.4222999,
        longitude: -122.0843575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "4"),
    PlaceLocation(
        name: 'Location 5',
        latitude: 37.4222999,
        longitude: -122.0843575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "5"),
    PlaceLocation(
        name: 'Location 6',
        latitude: 37.4222999,
        longitude: -122.0843575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "5"),
    PlaceLocation(
        name: 'Location 7',
        latitude: 37.4222999,
        longitude: -122.0843575,
        radius: 1,
        address: "Khan uul",
        userId: "1",
        id: "5"),
  ];

  bool isEditing = false;

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
            "Байршил",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.mode_edit_outline_outlined,
                  color: Colors.brightOrange),
              color: Colors.black,
              onPressed: () {
                setState(() => isEditing = !isEditing);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (context, index) {
                // add a divider between items
                return const Divider(
                  height: 5,
                  color: Colors.ligthBlack,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: isEditing
                      ? IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationAlertDialog(
                                      title: "Are you sure?",
                                      content: "test",
                                      confirmButtonText: "yes",
                                      cancelButtonText: "no",
                                      onConfirmPressed: () =>
                                          (locations.removeAt(index)),
                                      onCancelPressed: () =>
                                          (Navigator.pop(context)));
                                });
                            // locations.removeAt(index);
                          })
                      : Icon(Icons.house, color: Colors.brightOrange),
                  title: Row(
                    children: [
                      isEditing
                          ? Icon(Icons.house, color: Colors.brightOrange)
                          : const SizedBox(),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          locations[index].name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/locationDetails');
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.brightOrange,
                border: Border.all(
                  color: Colors.brightOrange,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addLocation');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.brightOrange), // background color
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100)), // size
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // border radius
                )),
              ),
              child: const Text(
                "Байршил нэмэх",
                style: TextStyle(color: Colors.ligthBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
