import 'package:flutter/foundation.dart';

class DeviceModel {
  final String name;
  String id;
  final DateTime created_at;
  final String user_id;
  String token;
  final DateTime create_date;
  final DateTime update_date;

  DeviceModel({
    required this.name,
    required this.created_at,
    required this.user_id,
    required this.token,
    required this.id,
    required this.create_date,
    required this.update_date,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
        name: json['name'],
        created_at: DateTime.fromMillisecondsSinceEpoch(
            json['created_at'].millisecondsSinceEpoch),
        token: json['token'],
        user_id: json['user_id'],
        id: json['id'],
        create_date: (json['create_date']).toDate(),
        update_date: (json['create_date']).toDate());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'created_at': created_at,
        'id': id,
        'token': token,
        'user_id': user_id,
        "create_date": create_date,
        "update_date": update_date
      };
}
