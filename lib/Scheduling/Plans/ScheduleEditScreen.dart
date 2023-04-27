import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';

class DisplayScheduleEdit extends StatefulWidget {
  final DocumentReference plan;

  const DisplayScheduleEdit({Key? key, required this.plan}) : super(key: key);

  @override
  ScheduleEdit createState() => ScheduleEdit();
}

class ScheduleEdit extends State<DisplayScheduleEdit> {
  // David Parkin
  // Initializers
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  // Get Timestamp from Firebase and Convert to DateTime
  DateTime dateTime = DateTime.now();

  // Colin Tran
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();



    bool remind = false;
    bool repeat = false;

    widget.plan.get().then((value) {
      _titleTextController.text = value.get('title');
      _bodyTextController.text = value.get('description');
      timeInput.text = value.get('time');
      dateTime = value.get('date').toDate();
      remind = value.get('remind');
      repeat = value.get('repeat');
    });

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    TimeOfDay time = TimeOfDay(hour: 8, minute: 30);

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(
              _titleTextController.text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: const <Widget>[]
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTextController,
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _bodyTextController,
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  style: TextStyle(fontSize: 18),
                  maxLines: null,
                ),
                TextFormField(
                    controller: timeInput,
                    decoration: InputDecoration(
                        icon: Icon(Icons.access_time_outlined),
                        labelText: "Pick Time"
                    ),
                    readOnly: false,
                    style: TextStyle(fontSize: 18),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: time
                      );

                      if (newTime == null) return;

                      setState(() {
                        time = newTime;
                        timeInput.text = newTime.format(context);
                      });
                    }
                ),
                TextFormField(
                    controller: dateInput,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date"
                    ),
                    readOnly: false,
                    style: TextStyle(fontSize: 18),
                    onTap: () async{
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(DateTime.now().year + 5),
                      ).then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
                        });
                      });
                    }
                ),
                // David Parkin
                ElevatedButton(
                  onPressed: () {

                    // Get the edited field values from the controllers
                    String title = _titleTextController.text;
                    String description = _bodyTextController.text;
                    //String location = _locationTextController.text;
                    String time = timeInput.text;

                    // Update the document in the Firestore database
                    FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Plan').collection('Plans').doc(widget.plan.id).update({
                      'title': title,
                      'description': description,
                      'time': time,
                    });

                    // Update the screen with the new field values
                    setState(() {
                      Map<String,dynamic> data = {
                        'title' : title,
                        'description' : description,
                        'time' : time,
                      };

                      widget.plan.update(data);
                      Navigator.of(context).pop();
                    });

                  },
                  child: Text('Submit'),
                ),
              ],
            )
        )
    );

  }}