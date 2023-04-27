import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'CalendarItem.dart';
import 'Calendar_Event.dart';
import 'Plans/Schedule.dart';

// Screen that displays calendar with both users' plans and events for the month
class compare_schedule extends StatefulWidget {
  // Requires params when calling this screen
  final int month;
  final String compareId;

  const compare_schedule({Key? key, required this.compareId, required this.month}) : super(key: key);

  _compareSchedule createState() => _compareSchedule();

}

class _compareSchedule extends State<compare_schedule> {
  // Initializes database
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;
  late String userId;

  // Calendar variables
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Calendar_Event>> _cal_events;

  // Hash equation to for HashList
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // Initializes Calendar variables and User Id
  @override
  void initState() {
    super.initState();
    _cal_events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    User? user = auth.currentUser;
    if (user != null){
      userId = user.uid;
    }

    DateTime _compareStartDate = DateTime(DateTime.now().year, widget.month, 1);
    DateTime _compareEndDate = DateTime(DateTime.now().year, widget.month + 1, 0);

    _focusedDay = _compareStartDate;
    _firstDay = _compareStartDate;
    _lastDay = _compareEndDate;
    _selectedDay = _compareStartDate;
    _calendarFormat = CalendarFormat.month;
    _loadAllCalendarSchedule();
  }

  // Loads all users' plans and events
  // Adds to calendar list
  _loadAllCalendarSchedule() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _cal_events = {};

    var snap = await FirebaseFirestore.instance
        .collection('Users').doc(userId).collection('Schedules').doc('Plan').collection('Plans')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
        fromFirestore: Calendar_Event.fromPlanFirestore,
        toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final cal_event = doc.data();

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    snap = await FirebaseFirestore.instance
        .collection('Users').doc(userId).collection('Schedules').doc('Event').collection('Event')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
        fromFirestore: Calendar_Event.fromEventFirestore,
        toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final cal_event = doc.data();

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    snap = await FirebaseFirestore.instance
        .collection('Users').doc(widget.compareId).collection('Schedules').doc('Plan').collection('Plans')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
        fromFirestore: Calendar_Event.fromOtherPlanFirestore,
        toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final cal_event = doc.data();

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    snap = await FirebaseFirestore.instance
        .collection('Users').doc(widget.compareId).collection('Schedules').doc('Event').collection('Event')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
        fromFirestore: Calendar_Event.fromOtherEventFirestore,
        toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final cal_event = doc.data();

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    var invited = await FirebaseFirestore.instance
        .collection('Users').doc(userId).collection('Schedules').doc('Event').collection('InvitedEvents')
        .where('eventDate', isGreaterThanOrEqualTo: firstDay)
        .where('eventDate', isLessThan: lastDay).get();

    for (var doc in invited.docs) {
      String title = '';

      var docRef = FirebaseFirestore.instance
          .collection('Users').doc(doc.get('userId')).collection('Schedules').doc('Event').collection('Event').doc(doc.get('eventId'))
          .withConverter(
          fromFirestore: Calendar_Event.fromEventFirestore,
          toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore());

      var docSnap = await docRef.get();

      final cal_event = docSnap.data()!;

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    invited = await FirebaseFirestore.instance
        .collection('Users').doc(widget.compareId).collection('Schedules').doc('Event').collection('InvitedEvents')
        .where('eventDate', isGreaterThanOrEqualTo: firstDay)
        .where('eventDate', isLessThan: lastDay).get();

    for (var doc in invited.docs) {
      String title = '';

      var docRef = FirebaseFirestore.instance
          .collection('Users').doc(doc.get('userId')).collection('Schedules').doc('Event').collection('Event').doc(doc.get('eventId'))
          .withConverter(
          fromFirestore: Calendar_Event.fromOtherEventFirestore,
          toFirestore: (Calendar_Event cal_event, options) => cal_event.toFirestore());

      var docSnap = await docRef.get();

      final cal_event = docSnap.data()!;

      final day =
      DateTime.utc(cal_event.date.year, cal_event.date.month, cal_event.date.day);
      if (_cal_events[day] == null) {
        _cal_events[day] = [];
      }

      if (_cal_events[day]!.contains(cal_event)) {
        int index = _cal_events[day]!.indexWhere((element) => element == cal_event);

        cal_event.setType('shared');

        _cal_events[day]![index] = cal_event;
      }

      _cal_events[day]!.add(cal_event);
    }

    setState(() {});
  }

  // Retrieves plans/events for the selected day from the list
  List<Calendar_Event> _getEventsForTheDay(DateTime day) {
    return _cal_events[day] ?? [];
  }

  // Builds screen
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Compare Schedule'),
            actions: const <Widget>[]
        ),

        body: ListView(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible : false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              eventLoader: _getEventsForTheDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _loadAllCalendarSchedule();
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                print(_cal_events[selectedDay]);
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.blue,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(DateFormat('MMMM dd, yyyy').format(day), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  );
                },
                markerBuilder: (BuildContext context, date, _cal_events) {
                  if (_cal_events.isEmpty) return SizedBox();
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _cal_events.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            // height: 7,
                            width: 5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getCodeColor(_cal_events[index])),
                          ),
                        );
                      });
                },
              ),
            ),
            SizedBox(height: 20,),
            ..._getEventsForTheDay(_selectedDay).map(
                  (schedule) => CalendarItem(
                  schedule: schedule,
                  ),
            ),
          ],
        ),
      // Allows user to add a new plan/event
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => Schedule(
                selectedDay: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _loadAllCalendarSchedule();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Gets calendar color for type of event
  Color getCodeColor(dynamic e){
    switch (e.type) {
      case 'self_plan':
        return Colors.blue;
      case 'self_event':
        return Colors.blue;
      case 'other_plan':
        return Colors.yellow;
      case 'other_event':
        return Colors.yellow;
      case 'shared':
        return Colors.green;
    }
    return Colors.black;
  }
}


