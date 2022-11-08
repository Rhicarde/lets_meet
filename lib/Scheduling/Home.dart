import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Schedule.dart';

class Home extends StatefulWidget {

  final Function? toggleView;
  Home({this.toggleView});

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  int index = 1;
  bool _checked = false;
  bool _checked_01 = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: Theme.of(context).appBarTheme.centerTitle,
        title: const Text('Lets Meet'),
        actions: const <Widget>[]
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Schedule()));
      }
    ),
    bottomNavigationBar: NavigationBar(
      height: 60,
      selectedIndex: index,
      onDestinationSelected: (index) => setState(() => this.index = index),
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.punch_clock_outlined),
            selectedIcon: Icon(Icons.punch_clock),
            label: 'Upcoming'),
        NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings')
      ],
    ),
    body: <Widget> [
      Container(
        color:  Colors.red,
        alignment: Alignment.center,
        child: const Text("Upcoming")
      ),
      Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Weather"),
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            fit: StackFit.passthrough,
            children: [
              const Center(
                  child: Text("Schedule", style: TextStyle(fontWeight: FontWeight.bold))),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        alignment: Alignment.center),
                onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Declined"),
                        content: const Text("Compare request has been declined"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ok")),
                        ],
                      ),
                    );
                },
                child: const Text("Share")),
              ),
          ]
          ),
          CheckboxListTile(
            title: const Text("CECS 491A: Complete HW"),
            secondary: Icon(Icons.checklist),
            controlAffinity: ListTileControlAffinity.leading,
            value: _checked_01,
            onChanged: (bool? value) {
              setState(() {
                _checked_01 = value!;
              });
            }),
          CheckboxListTile(
              title: const Text("CECS 491A: Complete HW"),
              secondary: Icon(Icons.checklist),
              controlAffinity: ListTileControlAffinity.leading,
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              }),
          CheckboxListTile(
              title: const Text("Walk Dog"),
              secondary: Icon(Icons.checklist),
              controlAffinity: ListTileControlAffinity.leading,
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              }),
          CheckboxListTile(
              title: const Text("CECS 448: Study for Exam"),
              secondary: Icon(Icons.checklist),
              controlAffinity: ListTileControlAffinity.leading,
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              }),
          CheckboxListTile(
              title: const Text("CECS 429: LO7"),
              secondary: Icon(Icons.checklist),
              controlAffinity: ListTileControlAffinity.leading,
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              }),
          CheckboxListTile(
              title: const Text("Dentist Appointment"),
              secondary: Icon(Icons.checklist),
              controlAffinity: ListTileControlAffinity.leading,
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              })
        ]
      ),
      Container(
          color:  Colors.blue,
          alignment: Alignment.center,
          child: const Text("Settings")
      ),
    ][index],
  );
}



