import 'package:flutter/material.dart';
import '../models/globals.dart' as globals;
import '../models/database.dart';
import '../models/notificationModel.dart';

class LocationHistory extends StatefulWidget {
  const LocationHistory({super.key});

  @override
  State<LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<LocationHistory> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getUserNotification(globals.currentUser.id);
    setState(() {
      isLoading = false;
      globals.userNotifications.sort((a, b) => a.time.compareTo(a.time));
    });
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
      body: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: ListView.builder(
            itemCount: globals.userNotifications.length,
            itemBuilder: (BuildContext context, int index) {
              NotificationModel collection = globals.userNotifications[index];

              final date = collection.time;
              final userId = collection.user_id;
              final title = collection.title;
              final bodu = collection.body;
              if (userId == globals.currentUser.id) {
                return ListTile(
                  title: Text('$title'),
                  subtitle: Text('$bodu'),
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}
