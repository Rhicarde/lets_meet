import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayNotificationHistory extends StatefulWidget {

  //creating the DisplayNotificationHistory class
  final Function? toggleView;
  DisplayNotificationHistory({this.toggleView});

  _DisplayNotificationHistory createState() => _DisplayNotificationHistory();
}

class _DisplayNotificationHistory extends State<DisplayNotificationHistory>{

  //initializing the starting variables
  int index = 0;
  bool _checked = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    //creating the body for a page
    body: <Widget> [
      Column(
          children: [
            //creating a list of notifications that can range from recent to future dates
            CheckboxListTile( //notification
                title: const Text("Eat at 2PM with friend on Tuesday 2/14/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                }),
            CheckboxListTile( //notification
                title: const Text("Do homework at 6PM on Wednesday 2/15/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                }),
            CheckboxListTile( //notification
                title: const Text("Hangout with family at 8PM on Thursday 2/16/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                }),
            CheckboxListTile( //notification
                title: const Text("Go buy groceries at 3PM on Friday 2/17/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                }),
            CheckboxListTile( //notification
                title: const Text("Hangout with friends at 9PM on Saturday 2/18/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                }),
            CheckboxListTile( //notification
                title: const Text("Watch basketball game 6PM on Sunday 2/19/23"),
                secondary: Icon(Icons.checklist),
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked, //setting the checkbox for user and seeing if its checked
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                  });
                })
          ]
      ),
    ][index],
  );
}



