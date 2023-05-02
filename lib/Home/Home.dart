import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/Notes.dart';
import 'package:lets_meet/Scheduling/Weather/Weather.dart';
import '../../Database/Schedule Database.dart';
import '../../Login/Auth.dart';
import '../Scheduling/Events/DisplayEvents.dart';
import '../Scheduling/Plans/DisplaySchedule.dart';
import '../Scheduling/Plans/Schedule.dart';
import 'RequestMenu.dart';

// The main home screen that the user see's when logging on
// Displays weather, date, schedule, and event made for given day
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  // Initializing database and user
  User_Database db = User_Database();
  FirebaseAuth auth = FirebaseAuth.instance;

  // List to pair String month to int
  List<Pair> months = [
    Pair('Jan', 1), Pair('Feb', 2), Pair('Mar', 3), Pair('Apr', 4),
    Pair('May', 5), Pair('Jun', 6), Pair('Jul', 7), Pair('Aug', 8),
    Pair('Sep', 9), Pair('Oct', 10), Pair('Nov', 11), Pair('Dec', 12)
  ];

  // Date format - Month Name Day
  DateTime viewedDate = DateUtils.dateOnly(DateTime.now());
  var dateFormat = DateFormat('MMMM dd');

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

  // Init values
  // index is used to track dropdown user value
  int index = 0;
  // index_month used to track dropdown month value
  int index_month = 0;
  // saved userId
  String userId = '';
  // initial month value
  int month = 1;

  // Building screen
  @override
  Widget build(BuildContext context) {
    // Retrieve logged in user
    User? user = auth.currentUser;
    
    return Scaffold(
      // Prevents keyboard from pushing up widgets
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('LetsPlan'),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: const Icon(
                    Icons.note_add_outlined,
                    size: 26.0,
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Notes()),
                    );
                  },
                ),
            )
          ],
      ),

      // A side bar menu that allows user to view all incoming requests
      drawer: RequestMenu(),
      // Floating Action Button is used to add a new plan/event
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Schedule(selectedDay: DateTime.now(),)));
          }
      ),

      // Contains weather, text, schedule, and events in a column
      body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
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
                              builder: (ctx) => StreamBuilder(
                                  stream: db.getAllUsers(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      List<Pair>? list = snapshot.data?.docs.map((user) {
                                        return Pair(user.id, user.get('name'));
                                      }).toList();

                                      if (user != null) {
                                        list!.removeWhere((accounts) => accounts.a == user.uid);
                                        userId = list.first.a;
                                      }

                                      // Compare schedule selection dialog
                                      return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter dropdownState) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Compare Schedule"),
                                          content: SizedBox(
                                            height: 150,
                                            child: Column (
                                              children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [const Text('Select User')]),
                                                DropdownButton(
                                                  value: list![index].a,
                                                  isExpanded: true,
                                                  items: list.map<DropdownMenuItem<String>>((value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value.a,
                                                      child: Text('${value.b}'),
                                                    );
                                                  }).toList(),
                                                  onChanged: (Object? value) {
                                                    dropdownState(() {
                                                      index = list.indexWhere((element) => element.a == value!);
                                                      userId = value.toString();
                                                    });
                                                  },
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [const Text('Select Month')]),
                                                DropdownButton(
                                                    value: months[index_month].a,
                                                    items: months.map<DropdownMenuItem<String>>((value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value.a,
                                                        child: Text('${value.a}'),
                                                      );
                                                    }).toList(),
                                                  onChanged: (Object? value) {
                                                      dropdownState(() {
                                                        index_month = months.indexWhere((element) => element.a == value!);
                                                        month = months[index_month].b;
                                                      });
                                                },)
                                              ]
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  print(month);
                                                  // Send compare request
                                                  db.compare_request(userId: userId, month: month);

                                                  // Reset selection
                                                  index_month = 0;
                                                  index = 0;
                                                  userId = list.first.a;
                                                  month = 1;

                                                  // Removes alert
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Compare")),
                                            TextButton(
                                                onPressed: () {
                                                  // Reset selection
                                                  index_month = 0;
                                                  index = 0;
                                                  userId = list.first.a;
                                                  month = 1;

                                                  // Removes alert
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel")),
                                          ],
                                        );
                                      }

                                      );
                                    }
                                    else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                              )
                            );
                          },
                          child: const Text("Share")),
                    ),
                  ]
              ),

              // Displays schedule and events
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
                    icon: Text('${dateFormat.format(viewedDate)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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

// Pair class used to contain 2 objects
class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}



