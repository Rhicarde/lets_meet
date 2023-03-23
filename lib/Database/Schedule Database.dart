import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Scheduling/EventDetail.dart';
import '../Scheduling/PlanDetail.dart';

class User_Database {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // Write to database - Notes are the plans created by the users
  // Contains: title, body, time, reminder, and repeat
  void add_note({required String body, required bool remind, required bool repeat, required String title, required DateTime time}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .add({'body': body, 'remind': remind, 'repeat': repeat, 'title': title, 'time': time, 'titleSearch': titleSearchParam(title: title), 'completed': false});
    }
  }

  // Breaks down the title by character in order to be used for search
  titleSearchParam({required String title}) {
    title = title.toLowerCase();

    // List of words allow for search in between title
    List words = title.split(' ');

    List<String> titleSearchList = [];

    while (words.isNotEmpty) {
      String word = mergeTitle(words: words);
      String temp = "";
      for (int i = 0; i < word.length; i++){
        temp = temp + word[i];
        titleSearchList.add(temp);
      }
      words.removeAt(0);
    }

    return titleSearchList;
  }

  mergeTitle({required List words}) {
    String word = '';

    for (int i = 0; i < words.length; i++) {
      word += words[i];

      if (i != words.length){
        word += " ";
      }
    }

    return word;
  }

  complete_plan({required String id, required bool completion}){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .doc(id).update({'completed': completion});
    }
  }
  // Read from Database - Displays all user notes on home page
  getNotes() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans').snapshots();
    }
  }

  void remove_plan({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .doc(id).delete();
    }
  }

  // On account creation, write name and email to account as profile information
  void createProfile({required String name, required String email}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Profile').add({'name': name, 'email': email});
    }
  }

  // Reads user profile from database - returns name and email
  getUserInfo() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Profile').snapshots();
    }
  }

  getEvents(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event').snapshots();
    }
  }

  void remove_event({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('Event')
          .doc(id).delete();
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
            children: snapshot.data!.docs.map((plan) {
              return GestureDetector(
                key: Key(plan.get('title')),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPlanDetail(plan: plan))),
                child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child:ListTile(
                      title: Text(plan.get('title')),
                      leading: Checkbox(
                        value: plan.get('completed'),
                        onChanged: (bool? value) {
                          db.complete_plan(id: plan.id, completion: value!);
                        },

                      ),
                      // Delete Plan Button
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                        onPressed: () {
                          setState(() {
                            db.remove_plan(id: plan.id);
                          });
                        },
                      ),
                    )
                ),
              );

              /*Container(
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
              );*/
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
              return GestureDetector(
                key: Key(event.get('Title')),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: event))),
                child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child:ListTile(
                      title: Text(event.get('Title')),
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
            }).toList(),
          );
        },
      ),
    );
  }
}