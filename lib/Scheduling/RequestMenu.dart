import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Database/Schedule Database.dart';

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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(height: double.maxFinite, child: ListTile());
          }
          else if (snapshot.hasData) {
            return Drawer(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(context),
                    SizedBox(
                      height: double.maxFinite,
                      child: ListView(children: snapshot.data!.docs.map((request) {
                        return buildMenuItem(context, request);
                      }).toList()),
                    ),
                  ],
                ),
              ),
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

  Widget buildMenuItem(BuildContext context, QueryDocumentSnapshot<Object?> request) => Container(
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
}