import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/Event.dart';
import '../Database/Schedule Database.dart';
import '../Shared/constants.dart';

class DisplayEventDetail extends StatefulWidget {
  final QueryDocumentSnapshot event;

  const DisplayEventDetail({Key? key, required this.event}) : super(key: key);

  @override
  EventDetail createState() => EventDetail();
}

class EventDetail extends State<DisplayEventDetail> {
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
                      initialTime: time);

                  if (newTime == null) return;

                  setState(() {
                    time = newTime;
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
                  await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(DateTime.now().year + 5),).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
                    });
                  });
                }),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repeat? ", style: TextStyle(fontSize: 18)),
                Checkbox(
                    value: repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        repeat = value!;
                      });
                    }),
                Text("Remind? ", style: TextStyle(fontSize: 18)),
                Checkbox(
                    value: remind,
                    onChanged: (bool? value) {
                      setState(() {
                        remind = value!;
                      });
                    }),
              ],
            ),
            //TODO: Change Alert dialog to row
              // create textformfield with texediting controller and add button to side
              SingleChildScrollView(
                child: Column(
                    children: [
                Row(
                children:[
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Comments:",
                        style: TextStyle(
                          fontSize: 20, // adjust font size as needed
                          fontWeight: FontWeight.bold, // add bold font weight
                        ),
                      ),
                      for (var comment in widget.event.get('comments'))
                        Text(
                          comment,
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),

                ),
                      Spacer(),
                      SizedBox(
                        width: 100, // set the width of the button
                        child: ElevatedButton(
                            child: Text('Add', style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(50, 40), // set the height of the button
                            ),
                              onPressed: () async {
                                showDialog(context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text("Add Comment", style: TextStyle(fontSize: 18)),
                                      content: TextField(
                                        decoration: InputDecoration(
                                            hintText: "New Comment"
                                        ),
                                        onChanged: (String value){
                                          setState(() {
                                            String _documentID = widget.event.id;
                                            List _oldArray = [];
                                            _oldArray = widget.event.get('comments');
                                            _oldArray.add(value);
                                            FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Event').collection('Event').doc(_documentID).update({'comments': _oldArray});
                                          });
                                        },
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Add", style: TextStyle(fontSize: 18))
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                          ),
        )],
                      ),
                    ]
                ),
              ),
            ],
        )
    ));
  }
}