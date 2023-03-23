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


    // Time not yet implemented
    /*
    String formattedTime = '$hours:$minutes';
    timeInput.text = formattedTime;
    */

    bool remind = widget.event.get('remind');
    bool repeat = widget.event.get('repeat');

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(widget.event.get('title')),
            actions: const <Widget>[]
        ),
        body: Column(
          children: [
            TextFormField(
              controller: _titleTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
            ),
            TextFormField(
              controller: _bodyTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
            ),
            TextFormField(
              controller: _locationTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Location'),
            ),
            TextFormField(
              controller: timeInput,
              decoration: const InputDecoration(
                icon:Icon(Icons.access_time_outlined),
                labelText: "Pick Time"
              ),
              readOnly: false,
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: time);

                  // Cancel return NUll
                  if (newTime == null) return;

                  // OK return TimeofDay
                  setState(() {
                    time = newTime;
                  });
                  //db_time = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

                }
            ),
            TextFormField(
                controller: dateInput,
                decoration: const InputDecoration(
                    icon:Icon(Icons.calendar_today),
                    labelText: "Enter Date"
                ),
                readOnly: false,
                onTap: () async{
                  await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), // range of dates that calendar shows
                    lastDate: DateTime(DateTime.now().year + 5),).then((pickedDate) {
                    //then usually do the future job
                    if (pickedDate == null) {
                      //if user tap cancel then this function will stop
                      return;
                    }
                    setState(() {
                      //for rebuilding the ui
                      // updated dateTime
                      dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
                    });
                  });
                }),
            const SizedBox(height: 20,),
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
            // TODO: Create Row and TextFormField and place Add button on right
            // Change Alert Dialog to Row
            // TODO: Display username next to comment
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var comment in widget.event.get('comments')) Text(comment),
                  ElevatedButton(
                      child: Text('Add'),
                   onPressed: () async {
                        showDialog(context: context,
                        builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Add Comment"),
                          content: TextField(
                          decoration: InputDecoration(
                          hintText: "New Comment"),
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
                            ElevatedButton(onPressed: ()
                        {
                          Navigator.of(context).pop();
                          }, child: Text("Add")
                            )],
                        );
                       // DocumentReference doc_ref=FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Event').collection('Event').document();
                       // DocumentSnapshot docSnap = await doc_ref.get();
                       // var doc_id2 = docSnap.reference.documentID;
                        // figure out how to get doc id

                   },
                 );
                })]
              ),
            ),
          ],
        )
    );
  }
}