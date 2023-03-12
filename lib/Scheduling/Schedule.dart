import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/Schedule Database.dart';
import '../Login/Authentication/validator.dart';
import 'package:lets_meet/Scheduling/Event.dart';
import '../Shared/constants.dart';

class Schedule extends StatefulWidget {

  final Function? toggleView;
  Schedule({this.toggleView});

  _CreateSchedule createState() => _CreateSchedule();
}

class _CreateSchedule extends State<Schedule> {
  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now().subtract(Duration(days: DateTime
      .now()
      .day - 1));

  @override
  void initState() {
    super.initState();
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

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    String formattedTime = '$hours:$minutes';
    timeInput.text = formattedTime;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .appBarTheme
                .backgroundColor,
            centerTitle: Theme
                .of(context)
                .appBarTheme
                .centerTitle,
            title: const Text('Lets Plan'),
            actions: const <Widget>[]
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Schedule()));
                  },
                  style: TextButton.styleFrom(
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
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Event(DateTime.now())));
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.grey,
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
            const SizedBox(height: 20,),
            TextFormField(
              controller: _titleTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
            ),
            TextFormField(
              controller: _bodyTextController,
              validator: (value) =>
                  Validator.validateText(
                    text: value!,
                  ),
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
            ),
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
                    lastDate: DateTime(DateTime
                        .now()
                        .year + 5),).then((pickedDate) {
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
            TextFormField(
              controller: timeInput,
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer),
                  labelText: "Enter Time"
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: DateTime
                        .now()
                        .hour, minute: DateTime
                        .now()
                        .minute));
                if (time == null) return;
                setState(() {
                  //for rebuilding the ui
                  // display new selected time
                  String formattedTime = '$hours:$minutes';
                  timeInput.text = formattedTime;
                  // updated time
                  dateTime = DateTime(
                      dateTime.year, dateTime.month, dateTime.day, time.hour,
                      time.minute);
                });
              },
            ),
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
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    print(dateTime);
                    db.add_note(body: _bodyTextController.text,
                        remind: remind,
                        repeat: repeat,
                        title: _titleTextController.text,
                        time: dateTime);
                    Navigator.pop(context);
                  },
                  child: const Text('Create')),
            )
          ],
        )
    );
  }
}

