import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/database.dart';
import '../models/globals.dart' as globals;
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    String userId = await getCredentials();
    late User? curUser = null;

    curUser = await getUserDetails(userId);
    Logger().e(curUser?.id);

    if (curUser != null) {
      await login(curUser.name, curUser.password).then((value) {
        Navigator.pushNamed(context, "/homePage");
      });
    }
  }

  Future<String> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid') ?? '';
    return userid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Center(
          child: Container(
            height: 80.0,
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: (Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Colors.brightOrange,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: (const Icon(
                    Icons.supervisor_account,
                    color: Colors.ligthBlack,
                    size: 20.0,
                  )),
                ),
                const Text("Эцэг эх"),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.ligthBlack,
                  iconSize: 24.0,
                  onPressed: () {
                    Navigator.pushNamed(context, "/loginParent");
                  },
                )
              ],
            )),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Center(
          child: Container(
            height: 80.0,
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
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: (Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Colors.brightOrange,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: (const Icon(
                    Icons.supervisor_account,
                    color: Colors.ligthBlack,
                    size: 20.0,
                  )),
                ),
                const Text("Хүүхэд"),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.ligthBlack,
                  iconSize: 24.0,
                  onPressed: () {
                    Navigator.pushNamed(context, "/loginChild");
                  },
                )
              ],
            )),
          ),
        )
      ]),
    );
  }
}
