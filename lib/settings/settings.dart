import 'package:flutter/material.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => SettingsListState();
}

class SettingsListState extends State<SettingsList> {
  String username = "Сумъяахүү";
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
            "Тохиргоо",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brightOrange,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: const Icon(
                      Icons.person_2_outlined,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(username)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.7,
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, '/locationHistory');
                      });
                    },
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.history_edu,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Байршлын түүх')
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, '/DeviceList');
                      });
                    },
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.phone_iphone_rounded,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Баталгаажсан төхөөрөмжүүд')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle light when tapped.
                      });
                    },
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.ios_share_rounded,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Байршил хуваалцах')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle light when tapped.
                      });
                    },
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Шуурхай мэдэгдэл')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle light when tapped.
                      });
                    },
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.share_rounded,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Апп-ыг хуваалцах')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
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
              onPressed: () {},
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
                "Гарах",
                style: TextStyle(
                    color: Colors.ligthBlack, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
