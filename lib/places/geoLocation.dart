import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/popUpModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reference.dart';
import '../models/database.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({super.key});

  @override
  State<GeoLocation> createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  bool isEditing = false;
  bool isLoading = true;
  DB db = DB();
  Future<void> delete(PlaceLocation doc, int index) async {
    setState(() {
      isLoading = true;
    });
    db.deleteLocation(doc).then(
      (value) async {
        await db.getLocations();
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> init() async {
    await db.getLocations().then((value) {
      // ignore: unnecessary_null_comparison
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
          isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
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
                                icon:
                                    Icon(Icons.delete, color: Colors.red[400]),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmationAlertDialog(
                                            title: "Are you sure?",
                                            content: "test",
                                            confirmButtonText: "yes",
                                            cancelButtonText: "no",
                                            onConfirmPressed: () async {
                                              await delete(
                                                      locations[index], index)
                                                  .then((value) {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            onCancelPressed: () =>
                                                (Navigator.of(context).pop()));
                                      });
                                  // locations.removeAt(index);
                                })
                            : const Icon(Icons.house,
                                color: Colors.brightOrange),
                        title: Row(
                          children: [
                            isEditing
                                ? const Icon(Icons.house,
                                    color: Colors.brightOrange)
                                : const SizedBox(),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                locations[index].name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_outlined),
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15))),
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
