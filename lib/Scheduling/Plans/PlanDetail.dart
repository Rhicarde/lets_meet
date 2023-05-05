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

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _titleTextController,
                    decoration: textInputDecoration.copyWith(hintText: 'Title'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayScheduleEdit(plan: widget.plan.reference)));
                  },
                ),
              ],
            ),
            TextFormField(
              controller: _bodyTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
            ),
            TextFormField(
                controller: dateInput,
                decoration: const InputDecoration(
                    icon:Icon(Icons.calendar_today),
                    labelText: "Date and Time"
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
                      String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
                      dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';
                      // updated dateTime
                      dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, dateTime.hour, dateTime.minute);
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
                    onChanged: (bool? value) {}),
                Text("Remind? "),
                Checkbox(
                    value: remind,
                    onChanged: (bool? value) {}),
              ],
            ),
          ],
        )
    );
  }
}