import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/model/reminder_model.dart';

// ignore: must_be_immutable
class Switcher extends StatefulWidget {
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  String title;
  String body;
  Switcher(
      this.onOff, this.uid, this.id, this.timestamp, this.title, this.body);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: widget.onOff,
        onChanged: (bool value) {
          ReminderModel reminderModel = ReminderModel();
          reminderModel.onOff = value;
          reminderModel.timestamp = widget.timestamp;
          reminderModel.title = widget.title;
          reminderModel.body = widget.body;
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .collection('reminder')
              .doc(widget.id)
              .update(reminderModel.toMap());
        });
  }
}
