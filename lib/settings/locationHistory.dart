import 'package:flutter/material.dart';

class LocationHistory extends StatefulWidget {
  const LocationHistory({super.key});

  @override
  State<LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<LocationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Байршлын түүх",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  color: Colors.ligthBlack),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(children: const <Widget>[]),
    );
  }
}
