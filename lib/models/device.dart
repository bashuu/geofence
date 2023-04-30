import 'package:flutter/foundation.dart';

class DeviceModel {
  final String name;
  String id;
  final DateTime created_at;
  final String user_id;
  String token;

  DeviceModel(
      {required this.name,
      required this.created_at,
      required this.user_id,
      required this.token,
      required this.id});

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'],
      created_at: DateTime.fromMillisecondsSinceEpoch(
          json['created_at'].millisecondsSinceEpoch),
      token: json['token'],
      user_id: json['user_id'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'created_at': created_at,
        'id': id,
        'token': token,
        'user_id': user_id
      };
}
