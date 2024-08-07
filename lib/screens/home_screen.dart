import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/model/service/notification_logic.dart';
import 'package:reminder_app/utils/app_color.dart';
import 'package:reminder_app/widgets/add_reminder.dart';
import 'package:reminder_app/widgets/deleteReminder.dart';
import 'package:reminder_app/widgets/switcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotifications();
  }

  void listenNotifications() {
    NotificationLogic.onNotifications.listen((value) {});
  }

  void onClickedNotifications(String? payload) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          title: const Text(
            'Reminder App',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            addReminder(context, user!.uid);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: AppColors.primayG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(
                    0,
                    2,
                  ),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('reminder')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Nothing to Show'),
              );
            }
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data?.docs.length,
              itemBuilder: (context, index) {
                Timestamp t = data?.docs[index].get('time');
                String title = data?.docs[index].get('title');
                final reminderData = data?.docs[index].data();
                String body = data?.docs[index].get('body');
                DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                    t.microsecondsSinceEpoch);
                String formattedTime = DateFormat.jm().format(date);
                on = data!.docs[index].get('onOff');
                if (on || reminderData != null) {
                  NotificationLogic.showNotifications(
                    dateTime: date,
                    id: 0,
                    title: title ?? 'Reminder Title',
                    body: body ?? "Don't forget drink water",
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              formattedTime,
                              style: const TextStyle(fontSize: 30),
                            ),
                            subtitle: const Text('Everyday'),
                            trailing: Container(
                              width: 110,
                              child: Row(
                                children: [
                                  Switcher(
                                      on,
                                      user!.uid,
                                      data.docs[index].id,
                                      data.docs[index].get('time'),
                                      title,
                                      body),
                                  IconButton(
                                    onPressed: () {
                                      deleteReminder(context,
                                          data.docs[index].id, user!.uid);
                                    },
                                    icon: const FaIcon(
                                        FontAwesomeIcons.circleXmark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
