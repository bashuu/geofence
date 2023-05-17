import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geofence/geofence/peopleMap.dart';
import 'package:geofence/models/device.dart';
import 'package:geofence/places/geoLocation.dart';
import 'package:geofence/settings/settings.dart';
import 'package:geofence/models/globals.dart' as globals;
import 'package:logger/logger.dart';
import '../places/notification.dart' as notif;

import 'package:device_info/device_info.dart';

import 'models/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _selectedItemColor = Colors.darkerWhite;
  // final _unselectedItemColor = Colors.darkerWhite;
  final _selectedBgColor = Colors.brightOrange;
  final _unselectedBgColor = Colors.darkerWhite;
  int _selectedIndex = 0;
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        globals.deviceToken = value;
        saveToken(value);
      });
    });
  }

  void saveToken(String? token) async {
    String deviceName = " ";
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
      print('Running on ${androidInfo.model}');
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
      print('Running on ${iosInfo.utsname.machine}');
    }
    DeviceModel newDevice = DeviceModel(
        name: deviceName,
        created_at: DateTime.now(),
        user_id: globals.currentUser.id,
        token: token ?? " ",
        id: "",
        create_date: DateTime.now(),
        update_date: DateTime.now());
    addUserDevice(newDevice);
  }

  void initInfo() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      notif.Notification notification =
          notif.Notification(flutterLocalNotificationsPlugin);
      notification.flutterLocalNotificationsPlugin =
          flutterLocalNotificationsPlugin;
      notification.showNotificationWMessage(
          message.notification?.title ?? "", message.notification?.body ?? "");
    });
  }

  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  static const List<Widget> _widgetOptions = <Widget>[
    PeopleMap(),
    GeoLocation(),
    SettingsList()
  ];

  Widget _buildIcon(IconData iconData, int index) => SizedBox(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Material(
            color: _getBgColor(index).withOpacity(0.25),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(iconData),
                ],
              ),
              onTap: () => _onItemTapped(index),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.supervisor_account, 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.location_on, 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.settings, 2),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.brightOrange,
          unselectedItemColor: Colors.ligthBlack,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
