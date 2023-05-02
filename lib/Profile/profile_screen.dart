import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Database/Schedule Database.dart';

// Creates the profile screen page
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Store user information as variables
  String name = 'Unnamed';
  String? email = 'No email';
  String? phoneNumber = '0000000000';

  // Image data for profile picture
  // String? image = '';
  // File? imagxFile;

  User_Database db = User_Database();

  // Collects user data from Firebase Database and stores it in the variables
  Future _getDataFromDatabase() async {
    print(name);
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if(snapshot.exists) {
        setState(() {
          name = snapshot.data()!["name"];
          email = snapshot.data()!["email"];
          phoneNumber = snapshot.data()!["phoneNumber"];
          // image = snapshot.data()!["userImage"];

        });
      }
    });
  }

  // Runs first when the page loads
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  // Creates the UI for the profile page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      // Gathers user info into a data stream
      body: StreamBuilder(
          stream: db.getUserInfo(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            // Return an empty view if no data
            if (!snapshot.hasData) {
              return ListView();
            }
            // Get the first document in the user's information collection (there's only one document)
            var userInfoDoc = snapshot.data!.docs.first;

            // Returns a view with user info if there is data to be displayed
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          color: Colors.blue,
                          child: const Center(
                            child: Text('Background Image goes here'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child:Text(
                                userInfoDoc['name'],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child:Text(
                                userInfoDoc['email'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                    Positioned(
                      top: 150.0,
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]
                );
          }
      ),
    );
  }
}