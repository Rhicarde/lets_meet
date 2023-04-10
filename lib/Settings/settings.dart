import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Builds the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Creates the bar at the top of the screen
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: const [
          // Creates the label and icon for the account page
          ListTile(
            title: Text(
                "Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.account_box, size: 40,),
          ),
          // Creates a gap for padding between blocks
          SizedBox(
            height: 60,
          ),
          // Creates the label and icon for the privacy page
          ListTile(
            title: Text(
              "Privacy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.lock, size: 40,),
          ),
          // Creates a gap for padding between blocks
          SizedBox(
            height: 60,
          ),
          ListTile(
            // Creates the label and icon for the about page
            title: Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.privacy_tip, size: 40,),
          ),
          // Creates a gap for padding between blocks
          SizedBox(
            height: 60,
          ),
          // Creates the label and icon for the personalization options page
          ListTile(
            title: Text(
              "Personalization Options",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.person_add_alt_sharp, size: 40,),
          ),
          // Creates a gap for padding between blocks
          SizedBox(
            height: 60,
          ),
          // Creates the label and icon for the help page
          ListTile(
            title: Text(
              "Help",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.help, size: 40,),
          ),
        ],
      ),
    );
  }
}
