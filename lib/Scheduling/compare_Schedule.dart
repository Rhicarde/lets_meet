import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/Events/Event.dart';

class create_Schedule extends StatefulWidget {

  final Function? toggleView;
  create_Schedule({this.toggleView});

  _CreateSchedule createState() => _CreateSchedule();
}

class _CreateSchedule extends State<create_Schedule>{
  late final CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime dateTime = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = _focusedDay;

  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event> eList = [];

  // TODO: Optimize!
  List<Event> _getEventsForDay (DateTime day) {
    List<Event> list = <Event>[];
    for (Event e in eList) {
      if (DateUtils.isSameDay(e.date, day)){
        list.add(e);
      }
    }
    if (list.length > 1) {
      for (int i = 0; i < (list.length - 1); i++) {
        for (int j = 1; j < (list.length); j++) {
          if (list[i].date?.hour == list[j].date?.hour) {
            //list[i].color = Colors.red;
            //list[j].color = Colors.red;
          }
        }
      }
    }

    return list;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  void dispose() {
    _focusedDay = DateTime.now();

    super.dispose();
  }

  String error = "";
  bool check = false;

  Widget build(BuildContext context) {
    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Lets Meet'),
            actions: const <Widget>[]
        ),
        body: Column (
          children: [
            const SizedBox(
              height: 20,
            ),
            TableCalendar(
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
                outsideDaysVisible: true,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (BuildContext context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            // height: 7,
                            width: 5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getCodeColor(events[index])),
                          ),
                        );
                      });
                },
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime(DateTime.now().year, DateTime.now().month,) ,
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month'
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                          color: value[index].color
                        ),
                        child: ListTile(
                          title: Text('${value[index].state} | ${DateFormat('HH:mm').format(value[index].date)}'),
                          selectedTileColor: value[index].color,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
}

Color getCodeColor(dynamic e){
  return e.color;
}


