import 'package:geofence/models/device.dart';
import 'package:geofence/models/notificationModel.dart';
import 'package:geofence/models/user.dart';

import 'place.dart';

List<PlaceLocation> locations = [];
List<User> users = [];
List<User> locationUser = [];
List<NotificationModel> userNotifications = [];
List<DeviceModel> userDevices = [];

late PlaceLocation locationDetails;
late User currentUser;
late String token = "";
late String? deviceToken = "";
String otpCode = "";
String sentId = "";
