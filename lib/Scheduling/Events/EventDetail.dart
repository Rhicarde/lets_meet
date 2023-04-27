import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';
import 'EventInvitation.dart';
import 'package:lets_meet/Scheduling/Events/EventEditScreen.dart';
import 'package:lets_meet/Scheduling/OptimalDeparture.dart';


class DisplayEventDetail extends StatefulWidget {
  final DocumentReference event;

  const DisplayEventDetail({Key? key, required this.event}) : super(key: key);

  @override
  EventDetail createState() => EventDetail();
}

class EventDetail extends State<DisplayEventDetail> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _commentTextController = TextEditingController();

  // Get Timestamp from Firebase and Convert to DateTime
  DateTime dateTime = DateTime.now();

  bool remind = false;
  bool repeat = false;

  List<dynamic> comments = [];
  List<dynamic> userIds = [];

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  Future<Tuple> _loadEventData() async {
    var docSnap = await widget.event.get();

    return Tuple(docSnap.get('title'), docSnap.get('description'), docSnap.get('location'),
        docSnap.get('time'), docSnap.get('date'), docSnap.get('remind'),
        docSnap.get('repeat'), docSnap.get('comments'), docSnap.get('userIds'));
  }

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = formattedDate;
    TimeOfDay time = TimeOfDay(hour: 8, minute: 30);

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return FutureBuilder<Tuple>(
        future: _loadEventData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            _titleTextController.text = snapshot.data!.a;
            _bodyTextController.text = snapshot.data!.b;
            _locationTextController.text = snapshot.data!.c;
            timeInput.text = snapshot.data!.d;
            dateTime = snapshot.data!.e.toDate();
            remind = snapshot.data!.f;
            repeat = snapshot.data!.g;
            comments = snapshot.data!.h;
            userIds = snapshot.data!.i;

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  centerTitle: Theme.of(context).appBarTheme.centerTitle,
                  title: Text(_titleTextController.text,
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
                      for (String user in userIds)
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
                      controller: dateInput,
                      decoration: const InputDecoration(
                          icon:Icon(Icons.calendar_today),
                          labelText: "Enter Date"
                      ),
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
                                        for (var comment in comments)
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
          else {
            return CircularProgressIndicator();
          }
        }
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

class Tuple<T1, T2, T3, T4, T5, T6, T7, T8> {
  final T1 a;
  final T2 b;
  final T3 c;
  final T4 d;
  final T5 e;
  final T6 f;
  final T7 g;
  final T8 h;
  final T8 i;

  Tuple(this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h, this.i);
}