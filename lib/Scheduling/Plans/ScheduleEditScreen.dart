import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Database/Schedule Database.dart';
import '../../Shared/constants.dart';
import '../TabManager.dart';

class DisplayScheduleEdit extends StatefulWidget {
  final DocumentReference plan;

  const DisplayScheduleEdit({Key? key, required this.plan}) : super(key: key);

  @override
  ScheduleEdit createState() => ScheduleEdit();
}

class ScheduleEdit extends State<DisplayScheduleEdit> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();

  TextEditingController dateInput = TextEditingController(); // text editing controller for date text field
  TextEditingController timeInput = TextEditingController(); // text editing controller for time text field

  @override
  Widget build(BuildContext context) {
    User_Database db = User_Database();

    // Get Timestamp from Firebase and Convert to DateTime
    DateTime dateTime = DateTime.now();

    bool remind = false;
    bool repeat = false;

    widget.plan.get().then((value) {
      _titleTextController.text = value.get('title');
      _bodyTextController.text = value.get('description');
      timeInput.text = value.get('time');
      dateTime = value.get('date').toDate();
      remind = value.get('remind');
      repeat = value.get('repeat');
    });

    final hours = (dateTime.hour % 12).toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    dateInput.text = '$formattedDate ${DateFormat.jm().format(dateTime)}';

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: Text(
              _titleTextController.text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: const <Widget>[]
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleTextController,
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _bodyTextController,
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  style: TextStyle(fontSize: 18),
                  maxLines: null,
                ),
                TextFormField(
                    controller: dateInput,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Date and Time"
                    ),
                    readOnly: false,
                    style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {

                    // Get the edited field values from the controllers
                    String title = _titleTextController.text;
                    String description = _bodyTextController.text;
                    //String location = _locationTextController.text;
                    String time = timeInput.text;

                    // Update the document in the Firestore database
                    FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Schedules').doc('Plan').collection('Plans').doc(widget.plan.id).update({
                      'title': title,
                      'description': description,
                      'time': time,
                      'titleSearch' : titleSearchParam(title: title),
                    });

                    // Update the screen with the new field values
                    setState(() {
                      Map<String,dynamic> data = {
                        'title' : title,
                        'description' : description,
                        'time' : time,
                      };

                      widget.plan.update(data);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Pages()));
                    });

                  },
                  child: Text('Submit'),
                ),
              ],
            )
        )
    );
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

  // merges List<String> into one string
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
}