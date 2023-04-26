import 'package:flutter/foundation.dart';

class NotificationModel {
  final String title;
  final String body;
  late String id;
  late DateTime time;
  final String user_id;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    required this.id,
    required this.user_id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      time: json['time'],
      id: json['id'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        "body": body,
        'time': time,
        'id': id,
        'user_id': user_id
      };
}
