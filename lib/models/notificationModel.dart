import 'package:flutter/foundation.dart';

class NotificationModel {
  final String title;
  final String body;
  late String id;
  late DateTime time;
  final String user_id;
  final DateTime create_date;
  final DateTime update_date;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    required this.id,
    required this.user_id,
    required this.create_date,
    required this.update_date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        title: json['title'],
        body: json['body'],
        time: DateTime.fromMillisecondsSinceEpoch(json['time']),
        id: json['id'],
        user_id: json['user_id'],
        create_date: DateTime.fromMillisecondsSinceEpoch(json['create_date']),
        update_date: DateTime.fromMicrosecondsSinceEpoch(json['update_date']));
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        "body": body,
        'time': time,
        'id': id,
        'user_id': user_id,
        "create_date": create_date,
        "update_date": update_date
      };
}
