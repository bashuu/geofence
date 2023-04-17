import 'package:flutter/foundation.dart';

class User {
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final int id;
  final bool isParent;

  User(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.id,
      required this.isParent});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        address: json['address'],
        id: json['id'],
        isParent: json['isParent']);
  }
}
