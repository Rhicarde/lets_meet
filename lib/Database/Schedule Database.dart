import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User_Database {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  void add_note({required String body, required bool remind, required bool repeat, required String title, required DateTime time}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Notes').add({'body': body, 'remind': remind, 'repeat': repeat, 'title': title, 'time': time});
    }
  }

  getNotes() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Notes').snapshots();
    }
  }

  getEvents(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event').snapshots();
    }
  }
}

// Database Read Material
class DisplaySchedule extends StatefulWidget {
  const DisplaySchedule({Key? key}) : super(key: key);

  @override
  ReadSchedule createState() => ReadSchedule();
}

class ReadSchedule extends State<DisplaySchedule> {
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    return Scaffold(
      body: StreamBuilder(
        stream: db.getNotes(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return ListView();
          }
          return ListView(
            children: snapshot.data!.docs.map((note) {
              return Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.fromLTRB(20,30,20,30),
                  alignment: Alignment.center,
                  child:
                  ExpansionTile (
                    title: Text(note.get('title')),
                    children: [Text(note.get('body'))],
                  )
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class DisplayEvents extends StatefulWidget {
  const DisplayEvents({Key? key}) : super(key: key);

  @override
  ReadEvents createState() => ReadEvents();
}

class ReadEvents extends State<DisplayEvents> {
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    return Scaffold(
      body: StreamBuilder(
        stream: db.getEvents(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return ListView();
          }
          return ListView(
            children: snapshot.data!.docs.map((event) {
              return Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.fromLTRB(20,30,20,30),
                  alignment: Alignment.center,
                  child:
                  ExpansionTile (
                    title: Text(event.get('Title') as String),
                    children: [Text(event.get('Description') as String),
                      Text(event.get("Date") as String),
                      Text(event.get("Location") as String),
                      Text(event.get("Comments") as String)
                    ],
                  )
              );
            }).toList(),
          );
        },
      ),
    );
  }
}