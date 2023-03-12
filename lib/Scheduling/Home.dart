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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  User_Database db = User_Database();

  int index = 1;
  bool _checked = false;
  bool _checked_01 = false;


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

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
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: index,
        onDestinationSelected: (index) => setState(() => this.index = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.punch_clock_outlined),
              selectedIcon: Icon(Icons.punch_clock),
              label: 'Upcoming'),
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings')
        ],
      ),
      body: <Widget> [
        // Upcoming Events Container
        Container(
            color:  Colors.red,
            alignment: Alignment.center,
            child: const ShowNotification(),
        ),
        Column(
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
                              builder: (ctx) => Note()/*AlertDialog(
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
            ]
        ),
        Container(
            color:  Colors.blue,
            alignment: Alignment.center,
            child: const ProfileScreen(),
        ),
      ][index],
    );
  }
}



