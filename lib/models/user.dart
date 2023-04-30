import 'package:flutter/foundation.dart';

class User {
  final String name;
  final double latitude;
  final double longitude;
  late String id;
  late String parent_id;
  final String password;
  late String location_id;

  User(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.id,
      required this.parent_id,
      required this.password,
      required this.location_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        id: json['id'],
        parent_id: json['parent_id'],
        password: json['password'],
        location_id: json['location_id']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        "latitude": latitude,
        'longitude': longitude,
        'parent_id': parent_id,
        'id': id,
        'password': password,
        'location_id': location_id
      };
}
