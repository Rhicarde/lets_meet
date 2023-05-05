import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Notifications/Notification_Services.dart';
import '../../Database/Schedule Database.dart';
import '../../Login/Authentication/validator.dart';
import 'package:lets_meet/Scheduling/Events/Event.dart';
import '../../Shared/constants.dart';

// Screen to add info on a new plan
class Schedule extends StatefulWidget {
  final DateTime selectedDay;

  final Function? toggleView;
  Schedule({this.toggleView, required this.selectedDay});

  _CreateSchedule createState() => _CreateSchedule();
}

class _CreateSchedule extends State<Schedule> {
  // Controller to get text for title and description of plan
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  // Controllers to manage date and time
  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  TimeOfDay current_time = TimeOfDay.now();

  late DateTime dateTime;

  @override
  void initState() {
    super.initState();

    dateTime = widget.selectedDay;
  }

  String error = "";

  // Boolean variables to determine notifications
  bool remind = false;
  bool repeat = false;

  Widget build(BuildContext context) {
    // Database for the writes
    User_Database db = User_Database();

    // Date format
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';
    // Time format
    String formattedTime = current_time.format(context);
    timeInput.text = formattedTime;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Create Schedule'),
            actions: const <Widget>[]
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10,),
            // Button used to navigate between creating a plan or an event
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Schedule(selectedDay: dateTime,)));
                  },
                  style: TextButton.styleFrom(
                      minimumSize: const Size(150, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.grey),
                      )
                  ),
                  child: Text("Plan"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Event(selectedDay: dateTime,)));
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.grey,
                      minimumSize: const Size(150, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.grey),
                      )
                  ),
                  child: Text("Event"),
                )
              ],
            ),
            const SizedBox(height: 20,),
            // Text box for title of plan
            TextFormField(
              controller: _titleTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
            ),
            // Text box for description of plan
            TextFormField(
              controller: _bodyTextController,
              validator: (value) =>
                  Validator.validateText(
                    text: value!,
                  ),
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
            ),
            // Text box for date and time - will show calendar
            TextFormField(
                controller: dateInput,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Date and Time"
                ),
                readOnly: true,
                onTap: () async {
                  await DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    onChanged: (date) {
                      dateTime = date;
                      setState(() {
                        //for rebuilding the ui
                        // display new selected date
                        formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
                        dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';
                        });
                    },
                    onConfirm: (date) {},
                  );
                }),
            const SizedBox(height: 20,),
            // Checkboxes to determine repeation or notification
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repeat? "),
                Checkbox(
                    value: repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        repeat = value!;
                      });
                    }),
                Text("Remind? "),
                Checkbox(
                    value: remind,
                    onChanged: (bool? value) {
                      setState(() {
                        remind = value!;
                      });
                    }),
              ],
            ),
            // Creation button -> leads to writing to database
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    // Created Plan Notification if remind is true
                    if (remind) {
                      debugPrint('Notification Scheduled for $dateTime');
                      NotificationService().scheduleNotification(
                          title: "LetsPlan",
                          body: "${_titleTextController.text} deadline is here",
                          scheduledNotificationDateTime: dateTime);
                    }

                    db.add_note(description: _bodyTextController.text,
                        remind: remind,
                        repeat: repeat,
                        title: _titleTextController.text,
                        date: dateTime);
                    Navigator.pop(context);
                  },
                  child: const Text('Create')),
            )
          ],
        )
    );
  }
}

