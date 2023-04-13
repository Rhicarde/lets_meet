import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Scheduling/Home.dart';
import 'package:rxdart/rxdart.dart';

import '../Login/Auth.dart';
import '../Notifications/Notification_History.dart';
import '../Scheduling/Event.dart';
import '../Scheduling/EventDetail.dart';
import '../Scheduling/PlanDetail.dart';

class User_Database {
  //users in the database
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // Kieran King
  // Given a day and time, finds the beginning of the following day
  DateTime getBeginningOfNextDay(DateTime inputDate) {
    print(DateUtils.dateOnly(inputDate).add(const Duration(days: 1)).toString());
    return DateUtils.dateOnly(inputDate).add(const Duration(days: 1));
  }

  // Write to database - Notes are the plans created by the users
  // Contains: title, body, time, reminder, and repeat
  get query => null;

  // Write to database - Notes are the plans created by the users
  // Contains: title, body, time, reminder, and repeat
  void add_note({required String body, required bool remind, required bool repeat, required String title, required DateTime time}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          // .collection('Schedules')
          // .doc('Plan').collection('Plans')
          // .add({'body': body, 'remind': remind, 'repeat': repeat, 'title': title, 'time': time, 'titleSearch': titleSearchParam(title: title), 'completed': false});
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .add({'body': body, 'remind': remind, 'repeat': repeat, 'title': title, 'time': time, 'titleSearch': titleSearchParam(title: title), 'completed': false});
    }
  }

  void add_event({required String title, required String description, required String location, required bool remind, required bool repeat, required List<String> comments, required DateTime date, required String time, required List<String> userIds}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      print('Adding');
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('Event')
          .add({'title': title, 'description': description, 'date': date, 'time': time, 'location': location, 'repeat': repeat, 'remind': remind, 'comments': comments, 'userIds': userIds, 'titleSearch': titleSearchParam(title: title)});
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

  //getting the titles based on the plan search query of the user
  getSearch({required String query}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    query = query.toLowerCase();
    if (user != null) {
      print(query);

      return users.doc(user.uid)
          .collection('Schedules').doc('Plan').collection('Plans')
          .where("titleSearch", arrayContains: query).snapshots(); //making sure that the title contains what is searched
      }
    }

  //getting the titles based on the event search query of the user
  getEventSearch({required String query}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    query = query.toLowerCase();
    if (user != null) {
      print(query);

      return users.doc(user.uid)
          .collection('Schedules').doc('Event').collection('Event')
          .where("titleSearch", arrayContains: query).snapshots(); //making sure that the title contains what is searched
    }
  }

    // getDate(){
    //   FirebaseAuth auth = FirebaseAuth.instance;
    //   User? user = auth.currentUser;
    //   if (user != null) {
    //     return users.doc(user.uid)
    //         .collection('Schedules').doc("Event").collection("Event").snapshots();
    //     }
    //   StreamBuilder<QuerySnapshot>(
    //     stream: getDate(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       }
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return const Text('Loading...');
    //         default:
    //           if (!snapshot.hasData) {
    //             return const Text('No data');
    //           }
    //           QueryDocumentSnapshot event = snapshot.data!.docs[0]; // assuming there is only one document in the collection
    //           DateTime date = event.get('date').toDate();
    //           return Text('$date');
    //       }
    //     },
    //   );
    //
    // }

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

  // Started by Richard Huynh, but worked on by Kieran King
  // Read from Database - Displays all user plans on home page
  getNotes(DateTime planTime) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .where('time', isGreaterThanOrEqualTo: planTime)
          .where('time', isLessThan: getBeginningOfNextDay(planTime))
          .snapshots();
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
      print("Writing to Profile");
      users.doc(user.uid).set({'name': name, 'uid': user.uid});

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

  // Kieran King
  // Creates a list of all app users' ids
  getAllUsers() {
    return users.snapshots();
  }
  get_upcoming_Events(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event').snapshots();
    }
  }

  // Kieran King
  // Queries and returns a stream of events for a specific given day for the user
  getEvents(DateTime eventDate){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(eventDate))
          .where('date', isLessThan: Timestamp.fromDate(getBeginningOfNextDay(eventDate)))
          .snapshots();
      //final invitedEvents = users.doc(user.uid).collection('Schedules').doc('Event').
    }
  }
  // Kieran King
  // Creates a document with the given event id and the owner of the event's
  // user ID for easy invitation implementation in the future
  void addEventuser({required String eventId, required String userId, required Timestamp eventDate}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // If their is a user currently logged in, add a new document for an
    // event the user was invited to
    if (user != null) {
      users.doc(userId)
          .collection('Schedules')
          .doc('Requests')
          .collection('Requests')
          .add({'eventId': eventId, 'userId': user.uid, 'eventDate': eventDate});
    }
  }

  // getAllInvitedEvents() {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //
  //   if(user != null){
  //     final invitedEvents = users.doc(user.uid).collection('Schedules').doc('Event').collection('InvitedEvents')
  //         .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(eventDate))
  //         .where('date', isLessThan: Timestamp.fromDate(getBeginningOfNextDay(eventDate)))
  //         .snapshots();}
  // }

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

  checkRequests() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Requests').snapshots();
    }
  }

  void add_request({required QueryDocumentSnapshot request}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Accepted");
     users.doc(user.uid)
         .collection('Schedules')
         .doc('Event').collection('InvitedEvents').add({'userId': request.get('userId'), 'eventId': request.get('eventId'), 'eventDate': request.get('eventDate')});

      update_event_invitation(userId: request.get('userId'), eventId: request.get('eventId'));
      remove_request(id: request.id);
    }
  }

  void remove_request({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Removed");
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Requests')
          .doc(id).delete();
    }
  }

  Future<void> update_event_invitation({required String userId, required String eventId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Event Invitees List Being Updated");
      DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

      List<dynamic> usersList = qSnapshot.get('userIds');

      if (usersList.isNotEmpty) {
        if (usersList[0] == "") {
          usersList[0] == user.uid;
        }
      }
      else {
        Set<dynamic> usersSet = usersList.toSet();
        usersSet.add(user.uid);
        usersList = usersSet.toList();
      }

      users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).update({'userIds': usersList});
    }
  }

  get_user_name({required String userId}) async {
    QuerySnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId).collection('Profile').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapshot = qSnapshot.docs;

    Map<String, dynamic>? data = listSnapshot[0].data();

    return data["name"];
  }

  get_event_name({required String userId, required String eventId}) async {
    DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId).collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

    return qSnapshot.get('title');
  }

  getDate(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return users.doc(user.uid)
          .collection('Schedules').doc("Event").collection("Event").snapshots();
    }
  }

  get_event({required String eventId}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event').doc(eventId).snapshots();
    }
  }
}


//read date
// class DisplayDate extends StatefulWidget {
//   const DisplayDate({Key? key}) : super(key: key);
//
//   @override
//   ReadDate createState() => ReadDate();
// }
//
// class ReadDate extends State<DisplayDate> {
//   @override
//   Widget build(BuildContext context) {
//     User_Database db = User_Database();
//
//     return Scaffold(
//       body: StreamBuilder(
//         stream: db.getDate(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return ListView();
//           }
//           return ListView(
//             children: snapshot.data!.docs.map((schedules) {
//               return Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.blue,
//                   ),
//                   padding: const EdgeInsets.fromLTRB(20,30,20,30),
//                   alignment: Alignment.center,
//                   child:
//                   ExpansionTile (
//                     title: Text(schedules.get('title')),
//                     children: [Text(schedules.get('date'))],
//                   )
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

class DisplaySearch extends StatefulWidget {
  //creating the key for the display search
  final String query;
  const DisplaySearch({Key? key, required this.query}) : super(key: key);

  @override
  ReadSearch createState() => ReadSearch();
}

class ReadSearch extends State<DisplaySearch> {
  //this is where you read the search
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    //the search will return a list of found searches and if nothing found, then nothing is displayed
    return Scaffold(
        body: StreamBuilder(
          stream: db.getSearch(query:widget.query), //getting the search from database
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              print('No Search Data');
              return ListView(shrinkWrap: true,); //returning the list view of the searches
            }
            return StreamBuilder(
              stream: db.getEventSearch(query:widget.query), //getting the search from database
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> Eventsnapshot) {
                if (!snapshot.hasData) {
                  print('No Search Data');
                  return ListView(shrinkWrap: true,); //returning the list view of the searches
                }
                List<GestureDetector> eventList = Eventsnapshot.data!.docs.map((search) {
                  return GestureDetector(
                    key: Key(search.get('title')),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: search))),
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child:ListTile(
                          title: Text(search.get('title')),
                          // Delete Event Button
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                db.remove_event(id: search.id);
                              });
                            },
                          ),
                        )
                    ),
                  );
                }).toList();

                List<GestureDetector> searchList = snapshot.data!.docs.map((search) {
                  return GestureDetector(
                    key: Key(search.get('title')),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: search))),
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child:ListTile(
                          title: Text(search.get('title')),
                          // Delete Event Button
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever_rounded, color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                db.remove_event(id: search.id);
                              });
                            },
                          ),
                        )
                    ),
                  );
                }).toList();

                if (eventList.isNotEmpty) {
                  for (var gesture_detector in eventList) {
                    searchList.add(gesture_detector);
                  }
                }
                return Column(
                  children: searchList
                );
              },
            );
    },
        ),
    );
  }
}

// Database Read Material
class DisplaySchedule extends StatefulWidget {
  final DateTime viewedDate;
  const DisplaySchedule(DateTime this.viewedDate, {Key? key}) : super(key: key);

  @override
  ReadSchedule createState() => ReadSchedule();
}

class ReadSchedule extends State<DisplaySchedule> {
  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    return Scaffold(
      body: StreamBuilder(
        stream: db.getNotes(widget.viewedDate),
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

//creating the class to display the notification history
class DisplayNotificationHistory_ extends StatefulWidget {
  const DisplayNotificationHistory_({Key? key}) : super(key: key);

  @override
  ReadNotificationHistory_ createState() => ReadNotificationHistory_();
}

//creating the class to read the notification history
class ReadNotificationHistory_ extends State<DisplayNotificationHistory_> {
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
        stream: db.get_upcoming_Events(), //getting events from the database
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return ListView();
          }
          return ListView( //returning the information that is needed to display the notification history
            children: snapshot.data!.docs.map((event) {
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
                          color: Colors.amberAccent,
                          fontSize: 25)),
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


class DisplayEvents extends StatefulWidget {
  final DateTime viewedDate;
  const DisplayEvents(DateTime this.viewedDate, {Key? key}) : super(key: key);

  @override
  ReadEvents createState() => ReadEvents();
}

class ReadEvents extends State<DisplayEvents> {

  @override
  Widget build(BuildContext context) {

    User_Database db = User_Database();

    return Scaffold(
      body: StreamBuilder(
        stream: db.getEvents(widget.viewedDate),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return ListView();
          }
          return ListView(
            children: snapshot.data!.docs.map((event) {
              return GestureDetector(
                key: Key(event.get('title')),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: event))),
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
            }).toList(),
          );
        },
      ),
    );
  }
}