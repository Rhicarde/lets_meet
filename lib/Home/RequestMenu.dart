import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/Scheduling/compare_Schedule.dart';

import '../../Database/Schedule Database.dart';

class RequestMenu extends StatefulWidget {
  RequestMenu({Key? key}) : super(key: key);

  _RequestMenu createState() => _RequestMenu();
}

class _RequestMenu extends State<RequestMenu> {
  User_Database db = User_Database();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.checkRequests(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> event_snapshot) {
          if (!event_snapshot.hasData) {
            return Drawer(child: SizedBox(height: double.maxFinite, child: ListView()));
          }
          else if (event_snapshot.hasData) {
            return StreamBuilder(
              stream: db.checkCompareRequests(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> compare_snapshot) {
                if (!compare_snapshot.hasData) {
                  return Drawer(child: SizedBox(height: double.maxFinite, child: ListView()));
                }
                else if (compare_snapshot.hasData) {
                  return StreamBuilder(
                    stream: db.checkAcceptCompare(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> accept_snapshot) {
                      if (!accept_snapshot.hasData) {
                        return Drawer(child: SizedBox(height: double.maxFinite, child: ListView()));
                      }
                      else if (accept_snapshot.hasData) {
                        print('EVENT SNAPSHOTS: ${event_snapshot.data?.docs.length}');
                        print('COMPARE SNAPSHOTS: ${compare_snapshot.data?.docs.length}');
                        print('ACCEPT SNAPSHOTS: ${accept_snapshot.data?.docs.length}');

                        List<Widget> request = event_snapshot.data!.docs.map((request) {
                          return buildEventItem(context, request);
                        }).toList();

                        List<Widget> compare = compare_snapshot.data!.docs.map((request) {
                          return buildCompareItem(context, request);
                        }).toList();

                        List<Widget> accept = accept_snapshot.data!.docs.map((request) {
                          return buildAcceptCompareItem(context, request);
                        }).toList();

                        for (var c in compare) {
                          request.add(c);
                        }

                        for (var a in accept) {
                          request.add(a);
                        }

                        return Drawer(
                          child: SizedBox(
                            height: double.maxFinite,
                            child: ListView(children: request),
                          ),
                        );
                      }
                      else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            );
          }
          else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget buildHeader(BuildContext context) => Container(
    color: Colors.blue,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        SizedBox(height: 12,),
        Text('Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 12,),
      ],
    ),
  );

  Widget buildEventItem(BuildContext context, QueryDocumentSnapshot<Object?> request) => Container(
    padding: const EdgeInsets.all(10),
    child: Wrap(
      runSpacing: 16,
      children: [
        FutureBuilder(
            future: db.get_user_name(userId: request.get('userId')),
            builder: (BuildContext context, profile) {
              if (!profile.hasData) {
                return Card();
              }
              return FutureBuilder(
                future: db.get_event_name(userId: request.get('userId'), eventId: request.get('eventId')),
                builder: (BuildContext context, event) {
                  if (!event.hasData) {
                    return Card();
                  }
                  var dateFormat = DateFormat('MMMM dd, yyyy');
                  DateTime time = request.get('eventDate').toDate();

                  ButtonStyle acceptStyle = ElevatedButton.styleFrom(onSurface: Colors.green, textStyle: const TextStyle(fontSize: 16, color: Colors.white));
                  ButtonStyle declineStyle = ElevatedButton.styleFrom(onSurface: Colors.red, textStyle: const TextStyle(fontSize: 16, color: Colors.black));

                  return Container(
                    width: 300,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('${profile.data} has invited you to ${event.data} on ${dateFormat.format(time)}',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green), ),
                                onPressed: () {setState(() {
                                  db.add_request(request: request);
                                });
                                },
                                child: Text('Accept', style: TextStyle(fontSize: 16, color: Colors.white)),),
                              const SizedBox(width: 5,),
                              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), ),
                                onPressed: () {
                                setState(() {
                                  db.remove_request(id: request.id);
                                });},
                                child: Text('Decline', style: TextStyle(fontSize: 16, color: Colors.white)),),
                              const SizedBox(width: 8,),
                            ],
                          )
                        ]
                      ),
                    ),
                  );
                });
            }),
      ],
    ),
  );

  Widget buildCompareItem(BuildContext context, QueryDocumentSnapshot<Object?> request) => Container(
    padding: const EdgeInsets.all(10),
    child: Wrap(
      runSpacing: 16,
      children: [
        FutureBuilder(
            future: db.get_user_name(userId: request.get('userId')),
            builder: (BuildContext context, profile) {
              if (!profile.hasData) {
                return Card();
              }
              return Container(
                width: 300,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('${profile.data} has requested to compare schedule for the month of ${convert_month(request.get('month'))}',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green), ),
                              onPressed: () {setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => compare_schedule(compareId: request.get('userId'), month: request.get('month'))));
                                db.accept_compare_request(request: request);
                                db.remove_compare_request(id: request.id);
                              });
                              },
                              child: Text('Accept', style: TextStyle(fontSize: 16, color: Colors.white)),),
                            const SizedBox(width: 5,),
                            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), ),
                              onPressed: () {
                                setState(() {
                                  db.remove_compare_request(id: request.id);
                                });},
                              child: Text('Decline', style: TextStyle(fontSize: 16, color: Colors.white)),),
                            const SizedBox(width: 8,),
                          ],
                        )
                      ]
                  ),
                ),
              );
            }),
      ],
    ),
  );

  Widget buildAcceptCompareItem(BuildContext context, QueryDocumentSnapshot<Object?> request) => Container(
    padding: const EdgeInsets.all(10),
    child: Wrap(
      runSpacing: 16,
      children: [
        FutureBuilder(
            future: db.get_user_name(userId: request.get('userId')),
            builder: (BuildContext context, profile) {
              if (!profile.hasData) {
                return Card();
              }
              return Container(
                width: 300,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('${profile.data} has accepted the compare for the month of ${convert_month(request.get('month'))}',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green), ),
                              onPressed: () {setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => compare_schedule(compareId: request.get('userId'), month: request.get('month'))));
                                db.remove_accepted_compare_request(id: request.id);
                              });
                              },
                              child: Text('View', style: TextStyle(fontSize: 16, color: Colors.white)),),
                            const SizedBox(width: 5,),
                            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), ),
                              onPressed: () {
                                setState(() {
                                  db.remove_accepted_compare_request(id: request.id);
                                });},
                              child: Text('Dismiss', style: TextStyle(fontSize: 16, color: Colors.white)),),
                            const SizedBox(width: 8,),
                          ],
                        )
                      ]
                  ),
                ),
              );
            }),
      ],
    ),
  );
}

convert_month(int month) {
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  return months[month - 1];
}