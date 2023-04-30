
//creating the class to display the notification history
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Database/Schedule Database.dart';
import '../Login/Auth.dart';
import 'Notification_History.dart';

class DisplayUpcoming extends StatefulWidget {
  const DisplayUpcoming({Key? key}) : super(key: key);

  @override
  ReadUpcoming createState() => ReadUpcoming();
}

//creating the class to read the notification history
class ReadUpcoming extends State<DisplayUpcoming> {
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database(); //connecting to the user database

    return Scaffold(
      // Top bar that has Sign Out button
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('Upcoming'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: const Icon(
                    Icons.exit_to_app,
                    size: 26.0,
                  ),
                  onTap: () => FirebaseAuth.instance.signOut().then((res) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()),
                    );
                  },
                  ),
                )
            )
          ]
      ),
      body: StreamBuilder(
        stream: db.get_upcoming_Events(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)), //getting events from the database
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> eventSnap) {
          if (!eventSnap.hasData) {
            print('no event');
            return ListView();
          }
          return StreamBuilder(
              stream: db.get_upcoming_Plans(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> planSnap) {
                if (!planSnap.hasData) {
                  print('no plan');
                  return ListView(
                    children: eventSnap.data!.docs.map((event) {
                      return GestureDetector(
                        key: Key(event.get('title')), //getting the event name and information from events
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayNotificationHistory(event: event))),
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            color:Colors.blue,
                            child:ListTile(
                              title: Text(event.get('title'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25)),
                            )
                        ),
                      );
                    }).toList(),
                  );
                }

                List<Widget> eventWidgets = eventSnap.data!.docs.map((event) {
                  return GestureDetector(
                    key: Key(event.get('title')), //getting the event name and information from events
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayNotificationHistory(event: event))),
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color:Colors.blue,
                        child:ListTile(
                          title: Text(event.get('title'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25)),
                        )
                    ),
                  );
                }).toList();


                List<Widget> planWidget = planSnap.data!.docs.map((plan) {
                  return GestureDetector(
                    key: Key(plan.get('title')), //getting the event name and information from events
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPlanNotificationHistory(plan: plan))),
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color:Colors.blue,
                        child:ListTile(
                          title: Text(plan.get('title'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25)),
                        )
                    ),
                  );
                }).toList();

                for (var i in planWidget) {
                  eventWidgets.add(i);
                }

                return ListView( //returning the information that is needed to display the notification history
                    children: eventWidgets
                );
              });
        },
      ),
    );
  }
}