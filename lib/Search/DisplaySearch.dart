
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Scheduling/Plans/PlanDetail.dart';

import '../Database/Schedule Database.dart';
import '../Scheduling/Events/EventDetail.dart';

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

          // If no Plans, search in Events
          if (!snapshot.hasData) {
            print('No Plan Search Data');
            return StreamBuilder(
              stream: db.getEventSearch(query:widget.query), //getting the search from database
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> Eventsnapshot) {

                // If no Events, return empty Widget (no plans and events)
                if (!Eventsnapshot.hasData) {
                  print('No Event Search Data');
                  return ListView(shrinkWrap: true,); //returning the list view of the searches
                }

                // Else, return Events only
                List<GestureDetector> eventList = Eventsnapshot.data!.docs.map((search) {
                  return GestureDetector(
                    key: Key(search.get('title')),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: search.reference))),
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

                return Column(
                    children: eventList
                );
              }); //returning the list view of the searches
          }

          // Plans exist for search, check if Events exist
          return StreamBuilder(
            stream: db.getEventSearch(query:widget.query), //getting the search from database
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> Eventsnapshot) {

              // Events do not exist, return Plans only
              if (!Eventsnapshot.hasData) {
                print('No Event Search Data');

                List<GestureDetector> searchList = snapshot.data!.docs.map((search) {
                  return GestureDetector(
                    key: Key(search.get('title')),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: search.reference))),
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

                return Column(
                    children: searchList
                ); //returning the list view of the searches
              }

              // Both Events and Plans searched, display both
              List<GestureDetector> eventList = Eventsnapshot.data!.docs.map((search) {
                return GestureDetector(
                  key: Key(search.get('title')),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayEventDetail(event: search.reference))),
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
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPlanDetail(plan: search))),
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