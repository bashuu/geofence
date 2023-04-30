import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofence/geofence/peopleMap.dart';
import 'package:logger/logger.dart';
import 'package:otp/otp.dart';
import 'package:http/http.dart' as http;
import '../models/globals.dart' as globals;

import '../models/database.dart';

class LoginChildPage extends StatefulWidget {
  const LoginChildPage({super.key});

  @override
  State<LoginChildPage> createState() => _LoginChildPageState();
}

Future<void> sendPushMessage(String token, String title, String body) async {
  // Logger().i("Send Noti");
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA6nApToE:APA91bGgoSB0zwS8kUhtHTEpT5-kNHVz2ZWqAExFAVU49ykuXjob1BqqgarFrJ-ZetrWK8NSZaAvYVM0AtajFo3XaZ9eELkm165SGTesOfg0fB6gFp8VxzVKnbkbohV777HsP0jeEoAB',
  };
  final bodyJson = {
    'to': token,
    'priority': 'high',
    'notification': {
      'title': title,
      'body': body,
      "android_channel_id": "geofenceChannnel"
    },
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'sound': 'default',
      'status': 'done',
      'title': title,
      'body': body,
    },
  };

  try {
    await http.post(url, headers: headers, body: json.encode(bodyJson));
  } catch (e) {}
}

class _LoginChildPageState extends State<LoginChildPage> {
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String name = "";

    void generateOTPCode() async {
      await sendOTPCode(username.text);
      Logger().e("userid " + globals.sentId);
      await getUserDeviceList(globals.sentId).then((value) {
        for (int i = 0; i < globals.userDevices.length; i++) {
          sendPushMessage(
              globals.userDevices[i].token, "OTP message", globals.otpCode);
          Logger().e(globals.otpCode);
        }
        if (globals.userDevices.isNotEmpty) {
          Navigator.pushNamed(context, '/otpPage');
        }
      });
    }

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: AppBar(
                centerTitle: true,
                flexibleSpace: Container(),
                toolbarHeight: 50.0,
                backgroundColor: Colors.darkerWhite,
                leading: IconButton(
                  color: Colors.ligthBlack,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "Нэвтрэх",
                  style: TextStyle(
                    color: Colors.ligthBlack,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
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
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        controller: username,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            size: 20,
                          ),
                          hintText: 'Хэрэглэгчийн нэр',
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
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Хэрэглэгч рүү  OTP (нэг удаагийн код) илгээнэ. ",
                    style: TextStyle(
                      color: Colors.ligthBlack,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  Container(
                    height: 60.0,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: TextButton(
                      onPressed: () {
                        generateOTPCode();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.brightOrange), // background color
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 100)), // size
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // border radius
                        )),
                      ),
                      child: const Text(
                        "Илгээх",
                        style: TextStyle(color: Colors.ligthBlack),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
