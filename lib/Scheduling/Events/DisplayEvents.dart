
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Database/Schedule Database.dart';
import 'EventDetail.dart';

class DisplayEvents extends StatefulWidget {
  final DateTime viewedDate;
  const DisplayEvents(this.viewedDate, {Key? key}) : super(key: key);

  @override
  ReadEvents createState() => ReadEvents();
}

class ReadEvents extends State<DisplayEvents> {
  User_Database db = User_Database();

  DateTime getBeginningOfNextDay(DateTime inputDate) {
    return DateUtils.dateOnly(inputDate).add(const Duration(days: 1));
  }

  Future<List<Widget>> _loadInvitedEvents() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    List<Widget> eventWidgets = [];

    if (user != null) {
      var snap = await FirebaseFirestore.instance
          .collection('Users').doc(user.uid).collection('Schedules').doc('Event').collection('InvitedEvents')
          .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(widget.viewedDate))
          .where('eventDate', isLessThan: Timestamp.fromDate(getBeginningOfNextDay(widget.viewedDate))).get();

      List<Quid> invitedEvents = [];

      for (var doc in snap.docs) {
        String title = '';

        var temp = FirebaseFirestore.instance
            .collection('Users').doc(doc.get('userId')).collection('Schedules').doc('Event').collection('Event').doc(doc.get('eventId'));
        var docSnap = await temp.get();
        title = docSnap.get('title');

        invitedEvents.add(Quid(temp, title, doc.get('userId'), doc.get('eventId'), doc.id));
      }

      for (var i in invitedEvents) {
        eventWidgets.add(
            GestureDetector(
              key: Key(i.b),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: i.a))),
              child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child:ListTile(
                    title: Text(i.b),
                    // Delete Event Button
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                      onPressed: () {
                        setState(() {
                          db.remove_invited_event(userId: i.c, eventId: i.d, id: i.e);
                        });
                      },
                    ),
                  )
              ),
            )
        );
      }
    }

    return eventWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: db.getEvents(widget.viewedDate),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> event) {
          if (!event.hasData) {
            return ListView();
          }
          return FutureBuilder<List<Widget>>(
              future: _loadInvitedEvents(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else if (snapshot.hasData) {
                  List<Widget> eventWidgets = event.data!.docs.map((event) {
                    return GestureDetector(
                      key: Key(event.get('title')),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: event.reference))),
                      child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child:ListTile(
                            title: Text(event.get('title')),
                            // Delete Event Button
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                              onPressed: () {
                                setState(() {
                                  db.remove_event(id: event.id);
                                });
                              },
                            ),
                          )
                      ),
                    );
                  }).toList();

                  for (var i in snapshot.data!) {
                    eventWidgets.add(i);
                  }

                  return ListView(
                    children: eventWidgets
                  );
                }
                else {
                  return ListView(
                    children: event.data!.docs.map((event) {
                      return GestureDetector(
                        key: Key(event.get('title')),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: event.reference))),
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child:ListTile(
                              title: Text(event.get('title')),
                              // Delete Event Button
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                                onPressed: () {
                                  setState(() {
                                    db.remove_event(id: event.id);
                                  });
                                },
                              ),
                            )
                        ),
                      );
                    }).toList()
                  );
                }
              });
        },
      ),
    );
  }
}

class Quid<T1, T2, T3, T4, T5> {
  final T1 a;
  final T2 b;
  final T3 c;
  final T4 d;
  final T5 e;

  Quid(this.a, this.b, this.c, this.d, this.e);
}