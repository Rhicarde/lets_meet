import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'Notification_Services.dart';

DateTime scheduleTime = DateTime.now();

class DisplayNotification extends StatefulWidget {
  const DisplayNotification({super.key, required this.title});

  final String title;

  @override
  State<DisplayNotification> createState() => _DisplayNotificationState();
}

class _DisplayNotificationState extends State<DisplayNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DatePickerText(),
            ScheduleButton(),
          ],
        ),
      ),
    );
  }
}

class DatePickerText extends StatefulWidget {
  const DatePickerText({Key? key,}) : super(key: key);

  @override
  State<DatePickerText> createState() => _DatePickerTextState();
}

class _DatePickerTextState extends State<DatePickerText> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'LetsPlan',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}