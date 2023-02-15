import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotification extends StatelessWidget {
  const ShowNotification({Key? key}) : super(key: key);

  //creates a button to show notifications
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('show notification'), //a button to receive a notification
          onPressed: () async {
            notificationAlert();
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


