import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PlaceLocation {
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String address;
  final String userId;
  final String id;

  PlaceLocation(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.radius,
      required this.address,
      required this.userId,
      required this.id});

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      address: json['address'],
      userId: json['userId'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        "latitude": latitude,
        'longitude': longitude,
        'radius': radius,
        'address': address,
        'userId': userId,
        'id': id,
      };
}
