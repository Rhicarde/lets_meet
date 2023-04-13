
// Database Read Material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Database/Schedule Database.dart';
import 'PlanDetail.dart';

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
