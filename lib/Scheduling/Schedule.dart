import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Database/Schedule Database.dart';
import '../Login/Authentication/validator.dart';
import 'package:lets_meet/Scheduling/Event.dart';

class Schedule extends StatefulWidget {

  final Function? toggleView;
  Schedule({this.toggleView});

  _CreateSchedule createState() => _CreateSchedule();
}

class _CreateSchedule extends State<Schedule>{
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime dateTime = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = _focusedDay;

  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Event> eList = [Event(DateTime.now(), "Complete Homework")];

  // TODO: Optimize!
  List<Event> _getEventsForDay (DateTime day) {
    List<Event> list = <Event>[];
    for (Event e in eList) {
      if (DateUtils.isSameDay(e.date, day)){
        list.add(e);
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

  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();

  bool remind = false;
  bool repeat = false;

  Widget build(BuildContext context) {
    User_Database db = User_Database();

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Lets Meet'),
            actions: const <Widget>[]
        ),
        body: ListView (
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      minimumSize: const Size(150, 30),
                      shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.red),
                      )
                  ),
                  child: Text("Plan"),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      minimumSize: const Size(150, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red),
                      )
                  ),
                  child: Text("Event"),
                )
              ],
            ),
            TableCalendar(
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
            TextFormField(
              controller: _titleTextController,
              decoration: InputDecoration(
                hintText: "Title",
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _bodyTextController,
              validator: (value) => Validator.validateText(
                text: value!,
              ),
              decoration: InputDecoration(
                hintText: "Details",
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final time = await pickTime();
                  if (time == null) return;
                  final newDateTime = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, time.hour, time.minute);
                  setState(() => dateTime = newDateTime);
                },
                child: Text('$hours:$minutes')),
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
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    eList.add(Event(dateTime, "New"));
                    db.add_note(body: _bodyTextController.text, remind: remind, repeat: repeat, title: _titleTextController.text, time: dateTime);
                    Navigator.pop(context);
                  },
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



