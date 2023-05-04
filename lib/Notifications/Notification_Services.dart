import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    //local notifications plugin object
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    //setting the icon logo for the notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@letsmeet');

    //initializing the settings for android
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //initializing the initialization settings object
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  //creating the notification details
  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            importance: Importance.max),
        );
  }

  //displaying the notification when notificationDetails is called
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id,
        title,
        body,
        await notificationDetails());
  }

  //setting a notification date and time
  Future scheduleNotification(
      {int id = 0, //getting the required information for the notification
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(), //call notificationsDetails
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}