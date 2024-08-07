import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  Timestamp? timestamp;
  bool? onOff;
  String? title;
  String? body;

  ReminderModel({this.timestamp, this.onOff, this.body, this.title});

  Map<String, dynamic> toMap() {
    return {
      'time': timestamp,
      'onOff': onOff,
      'body': body,
      'title': title,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      timestamp: map['time'],
      onOff: map['onOff'],
    );
  }
}
