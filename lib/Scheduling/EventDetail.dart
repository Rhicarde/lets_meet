import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    _titleTextController.text = widget.event.get('title');
    _bodyTextController.text = widget.event.get('description');
    _locationTextController.text = widget.event.get('location');

    // Get Timestamp from Firebase and Convert to DateTime
    DateTime dateTime = widget.event.get('date').toDate();

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;

    // Time not yet implemented
    /*
    String formattedTime = '$hours:$minutes';
    timeInput.text = formattedTime;
    */

    bool remind = widget.event.get('remind');
    bool repeat = widget.event.get('repeat');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(widget.event.get('title')),
            leading: Builder(
              builder: (BuildContext context) {
                final ScaffoldState? scaffold = Scaffold.maybeOf(context);
                final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
                final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
                final bool canPop = parentRoute?.canPop ?? false;

                if (hasEndDrawer && canPop) {
                  return BackButton();
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            actions: const <Widget>[]
        ),
        endDrawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(context),
                for (String user in widget.event.get('userIds'))
                  FutureBuilder(
                    future: db.get_user_name(userId: user),
                    builder: (BuildContext context, AsyncSnapshot<Object?> profile) {
                      if (profile.hasData) {
                        return ListTile(leading: const Icon(Icons.person_outline), title: Text('${profile.data}'),);
                      }
                      else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var comment in widget.event.get('comments')) Text(comment)
                ],
              )
            )
          ],
        )
    );
  }

  Widget buildHeader(BuildContext context) => Container(
    color: Colors.blue,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        SizedBox(height: 12,),
        Text('Invitees',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 12,),
      ],
    ),
  );
}