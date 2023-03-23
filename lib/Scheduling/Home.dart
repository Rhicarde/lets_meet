import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Notifications/Notification_Services.dart';
import 'package:lets_meet/Profile/profile_screen.dart';
import 'package:lets_meet/Scheduling/Notes.dart';
import 'package:lets_meet/Scheduling/Weather/Weather.dart';
import '../Database/Schedule Database.dart';
import '../Login/Auth.dart';
import '../Login/Login.dart';
import '../main.dart';
import 'Schedule.dart';

// The main home screen that the user see's when logging on
// Displays weather, date, schedule, and event made for given day
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('Lets Plan'),
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Schedule()));
          }
      ),
      body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const WeatherPage(),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                  fit: StackFit.passthrough,
                  children: [
                    const Center(
                        child: Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold))),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              alignment: Alignment.center),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => Notes()/*AlertDialog(
                                title: const Text("Declined"),
                                content: const Text("Compare request has been declined"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok")),
                                ],
                              )*/,
                            );
                          },
                          child: const Text("Share")),
                    ),
                  ]
              ),
              Expanded(child: DisplaySchedule(),),
              const Center(
                  child: Text("Events", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: DisplayEvents(),),
            ]
        ),
    );
  }
}



