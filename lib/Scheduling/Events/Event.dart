import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';
import 'package:search_map_location/search_map_location.dart';

import '../../Database/Schedule Database.dart';
import '../../Notifications/Notification_Services.dart';
import '../../Shared/constants.dart';
import '../Plans/Schedule.dart';

// TODO: Link created event to schedule
class Event extends StatefulWidget {
  final DateTime selectedDay;
  const Event({Key? key, required this.selectedDay}) : super(key: key);

  // getter for date
  DateTime? get date => null;

  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<Event>{
  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController event_title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  // Variable Declarations
  // late CalendarFormat _calendarFormat = CalendarFormat.month;
  TimeOfDay current_time = TimeOfDay.now();


  // Getters
  get db => null;
  get hours => null;
  get minutes => null;

  String error = "";
  bool check1 = false;
  bool check2 = false;
  String db_title = "";
  String db_body = "";
  String db_location = "";
  String db_placeid = "";
  String event_comment = "";
  String input_comment = "";
  String cid = "";
  String db_time = DateFormat.jm().format(DateTime.now());

  late DateTime dateTime;

  @override
  void initState() {
    super.initState();

    dateTime = widget.selectedDay;
  }


  //@override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    User_Database db = User_Database();

    // declaring date variables for date dropdown
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';

    String formattedTime = current_time.format(context);
    timeInput.text = formattedTime;


    return Scaffold(
      // Create Event top AppBar
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Create Schedule'),
            actions: const <Widget>[]
        ),
        body: ListView (
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Schedule(selectedDay: dateTime,)));
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.grey,
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Event(selectedDay: dateTime,)));
                  },
                  style: TextButton.styleFrom(
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: event_title,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
              onChanged: (String text) {
                db_title = event_title.text;
              },
            ),
            TextFormField(
              controller: description,
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
              onChanged: (String text) {
                db_body = description.text;
              },
            ),
            // Date Selection Button
            // Upon Selecting a date display it on the button.
            TextFormField(
                controller: dateInput,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Date"
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

                        db_time = DateFormat.jm().format(dateTime);

                        formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
                        dateInput.text = '$formattedDate $db_time';


                      });
                    },
                    onConfirm: (date) {},
                  );
                }),
            const SizedBox(height: 20,),

            // TextFormField for Location Selection
            SearchLocation(
              apiKey: 'AIzaSyC7cVVVOgBwl3lQEJLZe-b8wCs0uVPq66Y', // Google Places API key
              placeType: PlaceType.address, // the user can only search addresses
              placeholder: 'Enter the location',
              language: 'en',
              country: 'US',
              onSelected: (Place place)async {
                setState(() {
                  // display chosen address
                  db_location = (place.placeId) as String;
                });
              },
              //   onSelected: (Place place) async {
              //   //final geolocation = await place.geolocation; // variable to store selected place
              //   db_location = (place.geolocation) as String;
              // },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repeat"),
                Checkbox(
                    value: check1,
                    onChanged: (bool? value) {setState(() {
                      check1 = value!;
                    });
                    }),
                Text("Remind"),
                Checkbox(
                    value: check2,
                    onChanged: (bool? value) {setState(() {
                      check2 = value!;
                    });})
              ],
            ),
            Container(
              // Button to add Event Comments
              child: ElevatedButton(
                onPressed: (){
                  showDialog(context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                    title: Text("Add Comment"),
                    content: TextField(
                      decoration: InputDecoration(
                      hintText: "New Comment"),
                      onChanged: (String value){
                        input_comment = value;
                      },
                      ),
                      actions:[
                        ElevatedButton(onPressed: () async{
                          Map<String, dynamic> eventCommentSave = {
                            "Comment" : input_comment
                      };
                      await FirebaseFirestore.instance.collection("Users").doc(user?.uid).collection('Schedules').doc("Event").collection("Comments").add(eventCommentSave).then((DocumentReference doc){
                      cid = doc.id; // document id of newly created note
                      });
                      Navigator.of(context).pop();
                      },
                      child: Text("Add"))
                      ]
                      );
                      });
                                  },
                                  child: const Text("Add Comment")
              )
            ),

            Container(

              child: ElevatedButton(
                  onPressed: ()  async {
                    // Created Event Notification if remind is true
                    if (check2) {
                      debugPrint('Notification Scheduled for $dateTime');
                      NotificationService().scheduleNotification(
                          title: "LetsPlan",
                          body: "Event: $db_title is starting",
                          scheduledNotificationDateTime: dateTime);
                    }

                    // Converting Place Id to Address to Store in Database
                    final geocoding = GoogleMapsGeocoding(
                      apiKey: 'AIzaSyC7cVVVOgBwl3lQEJLZe-b8wCs0uVPq66Y'
                    );
                    final response = await geocoding.searchByPlaceId(db_location);
                    final result = response.results[0].formattedAddress;
                    db_location = result as String;
                    //saving event data to database
                    db.add_event(title: db_title, description: db_body, location: db_location, remind: check2, repeat: check1, comments: [input_comment], date: dateTime, time: db_time, userIds: []);

                    Navigator.of(context).pop();
                  },
                  // Create Event Button
                  child: const Text('Create')),
            )
          ],
        )
    );
  }


  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
}
