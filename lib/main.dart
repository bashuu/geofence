import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geofence/Register/enterChildName.dart';
import 'package:geofence/Register/loginChild.dart';
import 'package:geofence/Register/loginParent.dart';
import 'package:geofence/Register/otpPage.dart';
import 'package:geofence/Register/registerPage.dart';
import 'package:geofence/Register/splashScreen.dart';
import 'package:geofence/Register/loginPage.dart';
import 'package:geofence/firebase_options.dart';
import 'package:geofence/geofence/peopleMap.dart';
import 'package:geofence/homePage.dart';
import 'package:geofence/places/addLocation.dart';
import 'package:geofence/places/geoLocation.dart';
import 'package:geofence/places/locationDetails.dart';
import 'package:geofence/places/userDetails.dart';
import 'package:geofence/settings/deviceList.dart';
import 'package:geofence/settings/locationHistory.dart';
import 'package:geofence/settings/notificationList.dart';
import 'package:geofence/settings/settings.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import '../places/notification.dart' as notif;
import 'package:logger/logger.dart';

Future<void> _backgroundMessagingHandler(RemoteMessage message) async {
  notif.Notification notification =
      notif.Notification(flutterLocalNotificationsPlugin);
  notification.flutterLocalNotificationsPlugin =
      flutterLocalNotificationsPlugin;
  notification.showNotificationWMessage(
      message.notification?.title ?? "", message.notification?.body ?? "");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Location location = Location();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessagingHandler);
  bool enabled = await location.serviceEnabled();
  if (await Permission.location.isDenied) {
    Permission.location.request();
  } else if (await Permission.locationAlways.isDenied) {
    Permission.location.request();
  } else if (!enabled) {
    enabled = await location.requestService();
  }

  runApp(const MyApp());
  ThemeData(
      appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.ligthBlack,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.brightOrange
          // primaryColor: Colors.ligthBlack,
          ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/loginPage': (context) => const LoginPage(),
        '/loginParent': (context) => const LoginParent(),
        '/registerPage': (context) => const RegisterPage(),
        '/loginChild': (context) => const LoginChildPage(),
        '/otpPage': (context) => const OtpPage(),
        '/peopleMap': (context) => const PeopleMap(),
        '/homePage': (context) => const HomePage(),
        '/geoLocation': (context) => const GeoLocation(),
        '/addLocation': (context) => const AddLocation(),
        '/locationDetails': (context) => const LocationDetails(),
        '/userDetails': (context) => const UserDetails(),
        '/settingsPage': (context) => const SettingsList(),
        '/enterChildName': (context) => const EnterChildName(),
        '/notificationList': (context) => const NotificationList(),
        '/DeviceList': (context) => const DeviceList(),
        '/locationHistory': (context) => const LocationHistory()
      },
    );
  }
}
