import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Notes extends StatefulWidget{
  _CreateNote createState() => _CreateNote();

}

class _CreateNote extends State<Notes>{
  // Initialize List and input string
  List Notes = [];
  String input = "";
  String nid = "";

  @override
  void initState() {
    // Notes.add("First Note");
    // Notes.add("Finish Code");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('Notes'),
          // Create Note Button
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  child: const Icon(
                    Icons.add,
                  ),
                  onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Create Note"),
                              content: TextField(
                                decoration: InputDecoration(
                                hintText: "New Note"),
                                onChanged: (String value){
                                  input = value;
                                },
                              ),
                                actions:[ // Create button adding the new notes to the list of notes
                                  ElevatedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> dataToSave = {
                                          'Note': input
                                        };
                                        await FirebaseFirestore.instance.collection("Users").doc(user?.uid).collection('Schedules').doc("Notes").collection("Notes").add(dataToSave).then((DocumentReference doc){
                                          nid = doc.id; // document id of newly created note
                                        });
                                        setState(() {
                                          Notes.add(input);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Create"))
    ],

                            );
                          });
                  },
              ),
            ),
    ],
    ),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: Notes.length,
                itemBuilder: (BuildContext context, int index){
                  // Delete an already existing note
                  return Dismissible(
                    key: Key(Notes[index]),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child:ListTile(
                        title: Text(Notes[index]),
                        // Delete Note Button
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever_rounded, color: Colors.red,),
                          onPressed: () {
                            // deleting document from database when x is clicked
                            FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc("Notes").collection("Notes").doc(nid).delete();

                            setState(() {
                              Notes.removeAt(index);
                            });
                          },

                        ),
                      )
                    ),
                  );
                }
              )
            )


    );



  }
}

