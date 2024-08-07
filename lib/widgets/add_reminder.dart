import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/model/reminder_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminder_app/utils/app_color.dart';

final _titlecontroller = TextEditingController();
final _bodycontroller = TextEditingController();

addReminder(
  BuildContext context,
  String uid,
) {
  TimeOfDay time = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  // ignore: no_leading_underscores_for_local_identifiers
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
  }

  void add(String uid, TimeOfDay time, DateTime selectedDate) {
    try {
      DateTime now = DateTime.now();
      DateTime reminderDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        time.hour,
        time.minute,
      );

      // Check if the selected date and time are in the past
      if (reminderDateTime.isBefore(now)) {
        Fluttertoast.showToast(msg: 'Please select future date and time');
        return;
      }

      Timestamp timestamp = Timestamp.fromDate(reminderDateTime);
      ReminderModel reminderModel = ReminderModel();
      reminderModel.timestamp = timestamp;
      reminderModel.onOff = false;
      reminderModel.body = _bodycontroller.text;
      reminderModel.title = _titlecontroller.text;

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reminder')
          .doc()
          .set(reminderModel.toMap());

      Fluttertoast.showToast(msg: 'Reminder Added');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder:
          (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text('Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Select a Time For Reminder'),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _titlecontroller,
                  decoration: const InputDecoration(
                    hintText: 'title',
                  ),
                ),
                TextField(
                  controller: _bodycontroller,
                  decoration: const InputDecoration(
                    hintText: 'body',
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                    style: const TextStyle(
                      color: AppColors.primaryColor1,
                      fontSize: 20,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (newTime == null) return;
                    setState(
                      () {
                        time = newTime;
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.clock,
                        color: AppColors.primaryColor1,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        time.format(context).toString(),
                        style: const TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                add(
                  uid,
                  time,
                  selectedDate,
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
    },
  );
}
