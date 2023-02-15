import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/Schedule.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Shared/constants.dart';
import 'package:search_map_location/search_map_location.dart';

// TODO: Link created event to schedule
class Event extends StatefulWidget {
  // constructor
  Event(DateTime current_date, String s);
  // getter for date
  DateTime? get date => null;

  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<Event>{
  TextEditingController dateinput = TextEditingController(); // text editing controller for date text field
  // Variable Declarations
  // late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime dateTime = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = _focusedDay;
  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));


  // Getters
  get db => null;
  get hours => null;
  get minutes => null;




  // Event List Declaration
  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event> eList = [Event(DateTime.now(), "Complete Homework")];

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
  bool check = false;
  //final DateTime date;
  //final String state;
  Color color = Colors.blue;
  //Event(this.date, this.state);


  //@override
  Widget build(BuildContext context) {
    // declarations
    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    String title = "";
    String body = "";

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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
              onChanged: (String text) {
                title = text;
              },
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
              onChanged: (String text) {
                body = text;
              },
            ),
            // Date Selection Button
            // Upon Selecting a date display it on the button.
            TextFormField(
                controller: dateinput,
                decoration: const InputDecoration(
                  icon:Icon(Icons.calendar_today),
                  labelText: "Enter Date"
                ),
                readOnly: true,
                onTap: () async{
                  DateTime? selectedDate = await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), // range of dates that calendar shows
                    lastDate: DateTime(2025),);
                  formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate!);
                  setState(() {
                    dateinput.text = formattedDate; //changes UI when user selects a date
                  });
                },
            ),
            // TextFormField for Location Selection
            SearchLocation(
              apiKey: 'AIzaSyC7cVVVOgBwl3lQEJLZe-b8wCs0uVPq66Y', // Google Places API key
              placeType: PlaceType.address, // the user can only search addresses
              placeholder: 'Enter the location',
              language: 'en',
              country: 'US',
              onSelected: (Place place) async {
                final geolocation = await place.geolocation; // variable to store selected place
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repeat"),
                Checkbox(
                    value: false,
                    onChanged: (bool? value) {
                      setState(() {
                        value = true;
                      });
                    }),
                Text("Remind"),
                Checkbox(
                    value: check,
                    onChanged: (bool? value) {setState(() {
                      check = value!;
                    });})
              ],
            ),
            Container(

              child: ElevatedButton(
                  onPressed: () {
                    eList.add(Event(dateTime, "New"));
                    db.add_note(body: body, title: title);
                    Navigator.pop(context);
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
