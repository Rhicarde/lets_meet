import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';
import 'EventInvitation.dart';
import 'package:lets_meet/Scheduling/Events/EventEditScreen.dart';

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
  final _commentTextController = TextEditingController();

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    _titleTextController.text = widget.event.get('title');
    _bodyTextController.text = widget.event.get('description');
    _locationTextController.text = widget.event.get('location');
    timeInput.text = widget.event.get('time');

    // Get Timestamp from Firebase and Convert to DateTime
    DateTime dateTime = widget.event.get('date').toDate();

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    TimeOfDay time = TimeOfDay(hour: 8, minute: 30);

    bool remind = widget.event.get('remind');
    bool repeat = widget.event.get('repeat');

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: Text(widget.event.get('title'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _titleTextController,
                    decoration: textInputDecoration.copyWith(hintText: 'Title'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventEdit(event: widget.event)));
                  },
                ),
              ],
            ),
            TextFormField(
              readOnly: true,
              controller: _titleTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Title'),
            ),
            TextFormField(
              readOnly: true,
              controller: _bodyTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Description'),
              style: TextStyle(fontSize: 18),
              maxLines: null,
            ),
            TextFormField(
              readOnly: true,
              controller: _locationTextController,
              decoration: textInputDecoration.copyWith(hintText: 'Location'),
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              readOnly: true,
              controller: timeInput,
              decoration: InputDecoration(
                  icon: Icon(Icons.access_time_outlined),
                  labelText: "Pick Time"
              ),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Repeat? ", style: TextStyle(fontSize: 18)),
                Checkbox(
                    value: repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        repeat = value!;
                      });
                    }),
                Text("Remind? ", style: TextStyle(fontSize: 18)),
                Checkbox(
                    value: remind,
                    onChanged: (bool? value) {
                      setState(() {
                        remind = value!;
                      });
                    }),
              ],
            ),
            //TODO: Change Alert dialog to row
            // create textformfield with texediting controller and add button to side
            SingleChildScrollView(
              child: Column(
                  children: [
                    Row(
                        children:[
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Comments:",
                                  style: TextStyle(
                                    fontSize: 20, // adjust font size as needed
                                    fontWeight: FontWeight.bold, // add bold font weight
                                  ),
                                ),
                                for (var comment in widget.event.get('comments'))
                                  Text(
                                    comment,
                                    style: TextStyle(fontSize: 16),
                                  ),
                              ],
                            ),
                          ),
                        ]),
                    // Invite a Friend Button
                    // Kieran King
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.lightGreen,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      // When the button is pressed,
                      // open the event invitation page
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventInvitation(event: widget.event),
                            ));
                      },
                      child: const Text('Invite a Friend'),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
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