import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lets_meet/Database/Schedule%20Database.dart';

class ShowNotification extends StatefulWidget {
  const ShowNotification({Key? key}) : super(key: key);

  @override
  State<ShowNotification> createState() => _ShowNotificationState();

}
class _ShowNotificationState extends State<ShowNotification>{
  User_Database db = User_Database();
  @override
  Widget build(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    DateTime dateNow = DateTime.now();
    DateTime eventDate = db.getDate();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('show notification'), //a button to receive a notification
          onPressed: () async {
            //notificationAlert();
            //const DisplayDate();
          },
        ),
      ),
    );
  }
  notificationAlert() async {
    //local notifications plugin object
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    //setting the icon logo for the notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@letsmeet');

    //creating the initialization settings object
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //initializing the initialization settings object
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    //setting the parameters within the notification
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'channel ID',
      'channel name',
      description: 'channel description',
      importance: Importance.high,
    );

    //showing the set parameters of the notifications
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Alert!!!',
      'Details of this Notification!!!',
      NotificationDetails(
        android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description),
    ),
    );
  }
}

