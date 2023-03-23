import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/Schedule.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Shared/constants.dart';
import 'package:search_map_location/search_map_location.dart';


// TODO: Add Time
class Event extends StatefulWidget {
  // constructor
  Event(DateTime current_date);
  // getter for date
  DateTime? get date => null;

  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<Event>{
  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController event_title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  // Variable Declarations
  // late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime dateTime = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = _focusedDay;
  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  TimeOfDay time = TimeOfDay(hour: 8, minute: 30);


  // Getters
  get db => null;
  get hours => null;
  get minutes => null;



  // Event List Declaration
  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event> eList = [];

  // method to return all events on a given day
  List<Event> _getEventsForDay (DateTime day) {
    List<Event> list = <Event>[];
    for (Event e in eList) {
      if (DateUtils.isSameDay(e.date, day)){
        list.add(e);
      }
    }
    return list;
  }


  String error = "";
  bool check1 = false;
  bool check2 = false;
  String db_title = "";
  String db_body = "";
  String db_location = "";
  String event_comment = "";
  String input_comment = "";
  String cid = "";
  String db_time = "";
  //final DateTime date;
  //final String state;
  Color color = Colors.blue;
  //Event(this.date, this.state);


  //@override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    // declarations
    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');


    // declaring date variables for date dropdown
    DateTime selectedDate = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);


    return Scaffold(
      // Create Event top AppBar
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Create Event'),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Schedule()));
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Event(DateTime.now())));
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
                  await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    // range of dates that calendar shows
                    lastDate: DateTime(DateTime.now().year + 5),).then((pickedDate) {
                    //then usually do the future job
                    if (pickedDate == null) {
                      //if user tap cancel then this function will stop
                      return;
                    }
                    setState(() {
                      //for rebuilding the ui
                      // display new selected date
                      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
                      dateInput.text = formattedDate;
                      // updated dateTime
                      dateTime = DateTime(
                          pickedDate.year, pickedDate.month, pickedDate.day,
                          dateTime.hour, dateTime.minute);
                    });
                  });
                }),
            const SizedBox(height: 20,),


            // Time Display
            // Time Selector Button
            ElevatedButton(
                child: Text('${time.hour}:${time.minute}'),
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: time);

                  // Cancel return NUll
                  if (newTime == null) return;

                  // OK return TimeofDay
                  setState(() {
                    time = newTime;
                  });
                  db_time = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

                }),
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
                        input_comment += value;
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
                    // Converting Place Id to Address to Store in Database
                    final geocoding = GoogleMapsGeocoding(
                      apiKey: 'AIzaSyC7cVVVOgBwl3lQEJLZe-b8wCs0uVPq66Y'
                    );
                    final response = await geocoding.searchByPlaceId(db_location);
                    final result = response.results[0].formattedAddress;
                    db_location = result as String;
                    //saving event data to database
                    Map<String, dynamic> dataToSave = {
                      'title': db_title,
                      'description': db_body,
                      'date': dateTime,
                      'time': db_time,
                      'location': db_location,
                      'repeat': check1,
                      'remind': check2,
                      'comments': [input_comment]
                    };

                    // Add data to database
                    FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Event').collection('Event').add(dataToSave);
                    // eList.add(Event(dateTime, "New"));
                    // db.add_note(body: body, title: title);
                    //Navigator.pop(Schedule());
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Schedule()));
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
