import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Database/Schedule Database.dart';


// The Event Invitation Page
// This whole file was written by Kieran King
class EventInvitation extends StatefulWidget {

  // Create event invitation variables
  final DocumentReference event;
  const EventInvitation({required this.event});
  _EventInvitation createState() => _EventInvitation();
}

class _EventInvitation extends State<EventInvitation> {

  // Reference to the database
  User_Database db = User_Database();
  FirebaseAuth auth = FirebaseAuth.instance;

  // Direct link to another user's account for event invite testing
  String inviteId = "usINuOhqAyW5VxtVIEpobNdCDDJ3";

  int index = 0;
  String userId = '';

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    Timestamp dateTime = Timestamp.now();

    widget.event.get().then((value) {
      dateTime = value.get('date');
    });

    // Creates the UI structure of the page
    return Scaffold(
      // Creates the UI for the app bar at the top of screen
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: Text('Invite to Event')
      ),

      // Creates a column of buttons
      // Currently is just 1 for easy testing but will be a list of users in the future
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
              stream: db.getAllUsers(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Pair>? list = snapshot.data?.docs.map((user) {
                    return Pair(user.id, user.get('name'));
                  }).toList();

                  if (user != null) {
                    list!.removeWhere((accounts) => accounts.a == user.uid);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children:
                      list!.map<Card>((value) {
                        Icon icon = Icon(Icons.add_circle_outline);

                        return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child:ListTile(
                              title: Text(value.b),
                              leading: Icon(Icons.person_outline),

                              // Delete Event Button
                              trailing: IconButton(
                                color: Colors.blue,
                                icon: icon,
                                onPressed: () {
                                  setState(() {
                                    db.addEventuser(eventId: widget.event.id, userId: value.a, eventDate: dateTime);
                                  });
                                },
                              ),
                            )
                        );
                      }).toList(),
                    ),
                  );
                }
                else {
                  return CircularProgressIndicator();
                }
              }
          ),
        ],
      ),
    );
  }
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}