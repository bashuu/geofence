import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String username = "Сумъяахүү";
  String placeName = "Ажил";
  String time = "9:00";
  bool notificationEnter = true;
  bool notificationLeave = true;
  List<String> locationList = ["Location1", "Location2", "Location3"];
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
            "Хэрэглэгч",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
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
                    Icons.person,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          placeName,
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.brightOrange,
                    size: 24,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.ligthBlack,
                border: Border.all(
                  color: Colors.ligthBlack,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Мэдэгдэл :",
                style: TextStyle(color: Colors.darkerWhite),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.login_rounded,
              color: Colors.brightOrange,
            ),
            title: const Expanded(
              child: Text(
                'Ирхэд мэдэгдэл авах',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            trailing: Switch(
              // This bool value toggles the switch.
              value: notificationEnter,
              activeColor: Colors.brightOrange,
              activeTrackColor: Colors.ligthBlack,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  notificationEnter = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 2,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.ligthBlack,
                  border: Border.all(
                    color: Colors.ligthBlack,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.ligthBlack,
            ),
            title: const Expanded(
              child: Text(
                'Гархад мэдэгдэл авах',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            trailing: Switch(
              // This bool value toggles the switch.
              value: notificationLeave,
              activeColor: Colors.brightOrange,
              activeTrackColor: Colors.ligthBlack,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  notificationLeave = value;
                });
              },
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.ligthBlack,
                  ),
                ),
                ButtonTheme(
                  minWidth: 0,
                  height: 0,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month_outlined),
                    label: Text('16/Гур'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.ligthBlack,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.ligthBlack,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.ligthBlack,
                border: Border.all(
                  color: Colors.ligthBlack,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Мэдэгдэл :",
                style: TextStyle(color: Colors.darkerWhite),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              itemCount: locationList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.brightOrange,
                    ),
                    title: Expanded(
                      child: Text(
                        locationList[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    trailing: Text("11:00"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
