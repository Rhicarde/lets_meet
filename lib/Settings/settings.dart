import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Profile/profile_screen.dart';

import '../Login/Auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
        children: [

          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            // Creates the label and icon for the profile page
            title: Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.person, size: 40,),
          ),

          // Creates a gap for padding between blocks
          SizedBox(
            height: 60,
          ),

          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut().then((res) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
              });
            },
            // Creates the label and icon for the profile page
            title: Text(
              "Log Out",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            trailing: Icon(Icons.exit_to_app, size: 40,),
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
