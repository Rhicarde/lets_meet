import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';

class DisplayEventEdit extends StatefulWidget {
  final QueryDocumentSnapshot event;

  const DisplayEventEdit({Key? key, required this.event}) : super(key: key);

  @override
  EventEdit createState() => EventEdit();
}

class EventEdit extends State<DisplayEventEdit> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _commentTextController = TextEditingController();

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    _titleTextController.text = widget.event.get('title');
    _bodyTextController.text = widget.event.get('description');
    _locationTextController.text = widget.event.get('location');
    timeInput.text = widget.event.get('time');
    _commentTextController.text = widget.event.get('comments').join('\n');

    // Get Timestamp from Firebase and Convert to DateTime
    DateTime dateTime = widget.event.get('date').toDate();
    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    TimeOfDay time = TimeOfDay(hour: 8, minute: 30);

    bool remind = widget.event.get('remind');
    bool repeat = widget.event.get('repeat');

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(
              widget.event.get('title'),
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
            controller: _locationTextController,
            decoration: textInputDecoration.copyWith(hintText: 'Location'),
            style: TextStyle(fontSize: 18),
              readOnly: true,
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
            TextFormField(
              controller: _commentTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Comments'),
              style: TextStyle(fontSize: 18),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {

                // Get the edited field values from the controllers
                String title = _titleTextController.text;
                String description = _bodyTextController.text;
                String location = _locationTextController.text;
                String time = timeInput.text;
                List<String> comments = _commentTextController.text.split('\n').toList();

                // Update the document in the Firestore database
                FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Event').collection('Event').doc(widget.event.id).update({
                  'title': title,
                  'description': description,
                  'location': location,
                  'time': time,
                  'comments': comments,
                });

                // Update the screen with the new field values
                setState(() {
                  widget.event.get('comments')['title'] = title;
                  widget.event.get('description')['description'] = description;
                  widget.event.get('location')['location'] = location;
                  widget.event.get('time')['time'] = time;
                  widget.event.get('comments')['comments'] = comments;
                });

              },
              child: Text('Submit'),
            ),
          ],
        )
        )
    );

          }}