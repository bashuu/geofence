import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';

//AIzaSyBxg1MmdmQQ8L0xBL7nyDdArry59H2ZMkc
class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = "";

  Future<void> _getCurrentUserloc() async {
    final locData = await Location().getLocation();
    final staticImgUrl = LocationHelper.genLocationImage(
        latitude: locData.latitude, longitude: locData.longitude);
    setState(() {
      _previewImageUrl = staticImgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: _previewImageUrl == ""
            ? const Text("No location chosen", textAlign: TextAlign.center)
            : Image.network(
                _previewImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
      ),
      Row(
        children: <Widget>[
          IconButton(
            onPressed: _getCurrentUserloc,
            icon: const Icon(Icons.location_on),
          )
        ],
      )
    ]);
  }
}
