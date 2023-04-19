import 'package:flutter/material.dart';
import 'package:geofence/geofence/peopleMap.dart';
import 'package:geofence/places/geoLocation.dart';
import 'package:geofence/settings/settings.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
