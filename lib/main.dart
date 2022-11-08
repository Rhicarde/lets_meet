import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lets_meet/Database/TestRW.dart';
import 'package:lets_meet/Login/Login.dart';
import 'package:lets_meet/Scheduling/Home.dart';
import 'package:lets_meet/Scheduling/compare_Schedule.dart';

import 'Scheduling/Schedule.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root
  // of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      home: ReadData(),
    );
  }
}

class ReadData extends StatefulWidget {

  @override
  _ReadData createState() => _ReadData();
}

class _ReadData extends State<ReadData> {
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Lets Meet"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Schedule()));
          }
      ),
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