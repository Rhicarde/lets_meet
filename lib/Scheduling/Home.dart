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
import 'RequestMenu.dart';
import 'Schedule.dart';

// The main home screen that the user see's when logging on
// Displays weather, date, schedule, and event made for given day
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  // bool areDatesEqual(DateTime date1, DateTime date2) {
  //   if(date1.day == date2.day && date1.month == date2.month && date1.year == date2.year) {
  //     return true;
  //   }
  //   return false;
  // }

  DateTime viewedDate = DateUtils.dateOnly(DateTime.now());

  // Kieran King
  // Increases the currently viewed date on the home page by 1
  void viewNextDay() {
    viewedDate = viewedDate.add(const Duration(days: 1));
  }
  // Kieran King
  // Decreases the currently viewed date on the home page by 1
  void viewPreviousDay() {
    viewedDate = viewedDate.subtract(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar that has Sign Out button
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
      // A side bar menu that allows user to view all incoming requests
      drawer: RequestMenu(),
      // Floating Action Button is used to add a new plan/event
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Schedule()));
          }
      ),
      // Contains weather, text, schedule, and events in a column
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
              Expanded(child: DisplaySchedule(viewedDate),),
              const SizedBox(height: 20),
              const Center(
                  child: Text("Events", style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              Expanded(child: DisplayEvents(viewedDate),),

              // Kieran King
              // Creates a row of buttons which each change the day in different ways,
              // and automatically displays the events for the new day when changed
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  // Back arrow that decreases the day by 1
                  IconButton(
                      onPressed: () {
                        setState(() {
                          viewPreviousDay();
                        });
                        },
                      icon: Icon(Icons.arrow_left),
                    color: Colors.black,
                    iconSize: 50,
                  ),
                  // Calendar button that allows the user to select any date to observe the user's
                  // events on that specific day
                  IconButton(
                    onPressed: () async
                    {
                      // Creates the date picker dialog box
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: viewedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                      );
                      if (newDate == null) return;
                      setState(() => viewedDate = DateUtils.dateOnly(newDate));
                    },
                    icon: Icon(Icons.calendar_month),
                    color: Colors.black,
                    iconSize: 50,
                  ),
                  // Forward arrow that increases the day by 1
                  IconButton(
                    onPressed: ()
                    {
                      setState(() {
                        viewNextDay();
                      });
                    },
                    icon: Icon(Icons.arrow_right),
                    color: Colors.black,
                    iconSize: 50,
                  ),
                ]
              )
            ]
        ),
    );
  }
}



