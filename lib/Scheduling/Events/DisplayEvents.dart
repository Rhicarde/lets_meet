
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Database/Schedule Database.dart';
import 'EventDetail.dart';

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