import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Note extends StatefulWidget{
  _CreateNote createState() => _CreateNote();

}

class _CreateNote extends State<Note>{
  // Initialize List and input string
  List Notes = [];
  String input = "";

  @override
  void initState() {
    // Notes.add("First Note");
    // Notes.add("Finish Code");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('Notes'),
          // Create Note Button
          actions: <Widget>[
            FloatingActionButton(
                child: const Icon(
                  Icons.add,
                ),
                onPressed: (){
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
                                    onPressed: (){
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