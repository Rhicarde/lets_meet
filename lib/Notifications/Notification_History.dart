import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Shared/constants.dart';

//displaying notification history and creating a key for event
class DisplayNotificationHistory extends StatefulWidget {
  final QueryDocumentSnapshot event;
  const DisplayNotificationHistory({Key? key, required this.event}) : super(key: key);
  @override
  NotificationHistory createState() => NotificationHistory();
}

//getting the notification history from the database for event
class NotificationHistory extends State<DisplayNotificationHistory> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  @override
  //getting the information from events
  Widget build(BuildContext context) {
    _titleTextController.text = widget.event.get('title');
    _bodyTextController.text = widget.event.get('description');
    _locationTextController.text = widget.event.get('location');
    timeInput.text = widget.event.get('time');

    //getting the date from events to convert to the type DateTime
    DateTime dateTime = widget.event.get('date').toDate();
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;

    return Scaffold(
        appBar: AppBar(
            title: const Text("Notification History",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                color: Colors.white)
            ),
            actions: const <Widget>[]
        ),

        //format of the notifications history
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTextController, //title editor
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _bodyTextController, //description editor
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 20,
                ),
                TextFormField(
                  controller: _locationTextController, //location editor
                  decoration: textInputDecoration.copyWith(hintText: 'Location'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 18),
                ),
                TextFormField(
                    controller: timeInput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.access_time_outlined), //picture icon
                    ),
                    readOnly: true,
                    style: const TextStyle(fontSize: 20),
                ),
                TextFormField(
                    controller: dateInput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //picture icon
                    ),
                    readOnly: true,
                    style: const TextStyle(fontSize: 20),
                    ),
                const SizedBox(height: 10, width: 10,), //size of the box
              ],
            )
        ));
  }
}

//displaying notification history and creating a key for plan
class DisplayPlanNotificationHistory extends StatefulWidget {
  final QueryDocumentSnapshot plan;
  const DisplayPlanNotificationHistory({Key? key, required this.plan}) : super(key: key);
  @override
  PlanNotificationHistory createState() => PlanNotificationHistory();
}

//getting the notification history from the database for plan
class PlanNotificationHistory extends State<DisplayPlanNotificationHistory> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  @override
  //getting the information from plan
  Widget build(BuildContext context) {
    _titleTextController.text = widget.plan.get('title');
    _bodyTextController.text = widget.plan.get('description');

    //getting the date from events to convert to the type DateTime
    DateTime dateTime = widget.plan.get('date').toDate();
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;

    return Scaffold(
        appBar: AppBar(
            title: const Text("Notification History",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            actions: const <Widget>[]
        ),

        //format of the notifications history
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTextController, //title editor
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _bodyTextController, //description editor
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  readOnly: true,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 20,
                ),
                TextFormField(
                  controller: dateInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //picture icon
                  ),
                  readOnly: true,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10, width: 10,), //size of the box
              ],
            )
        ));
  }
}