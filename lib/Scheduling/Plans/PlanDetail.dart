import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';
import 'ScheduleEditScreen.dart';

class DisplayPlanDetail extends StatefulWidget {
  final QueryDocumentSnapshot plan;

  const DisplayPlanDetail({Key? key, required this.plan}) : super(key: key);

  @override
  PlanDetail createState() => PlanDetail();
}

class PlanDetail extends State<DisplayPlanDetail> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    _titleTextController.text = widget.plan.get('title');
    _bodyTextController.text = widget.plan.get('description');

    // Get Timestamp from Firebase and Convert to DateTime
    DateTime dateTime = widget.plan.get('date').toDate();

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    String formattedTime = '$hours:$minutes';
    timeInput.text = formattedTime;

    bool remind = widget.plan.get('remind');
    bool repeat = widget.plan.get('repeat');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(widget.plan.get('title')),
            actions: const <Widget>[]

        ),
        body: Column(
          mainAxisAlignment : MainAxisAlignment.start,
          crossAxisAlignment : CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _titleTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),

            ),

            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayScheduleEdit(plan: widget.plan.reference)));
              },
            ),
            TextFormField(
              controller: _bodyTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
            ),
            TextFormField(
                controller: dateInput,
                decoration: const InputDecoration(
                    icon:Icon(Icons.calendar_today),
                    labelText: "Enter Date"
                ),
                readOnly: true,
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
                      // display new selected date
                      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
                      dateInput.text = formattedDate;
                      // updated dateTime
                      dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, dateTime.hour, dateTime.minute);
                    });
                  });
                }),
            TextFormField(
              controller: timeInput,
              decoration: const InputDecoration(
                  icon:Icon(Icons.alarm_on_outlined),
                  labelText: "Enter Time"
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
                if (time == null) return;
                setState(() {
                  //for rebuilding the ui
                  // display new selected time
                  String formattedTime = '$hours:$minutes';
                  timeInput.text = formattedTime;
                  // updated time
                  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
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
          ],
        )
    );
  }
}