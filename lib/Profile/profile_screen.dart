import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Creates the profile screen page
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Store user information as variables
  String name = 'Kieran King';
  String? email = 'kieran.king@student.csulb.edu';
  String? phoneNumber = '2094143627';

  // Image data for profile picture
  // String? image = '';
  // File? imagxFile;

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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
          )
        ),
        centerTitle: true,
        //backgroundColor: Colors.pink.shade400,
        title: const Center(
          child: Text('Profile Screen'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.pink, Colors.deepOrange.shade300],
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   stops: const [0.2, 0.9],
          // )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // _showImageDialog
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                minRadius: 60.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    // backgroundImage: imagxFile == null
                    //   ?
                    //     NetworkImage(
                    //       image!
                    //     )
                    //     :
                    //     Image.file
                    //       (imagxFile!).image,
                  ),
              )
            ),
            // Creates a gap between the user information elements
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Creates the name element
                Text(
                  'Name : Jim Bob',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // _displayTextInputDialog
                  },
                  icon: const Icon(Icons.edit),
                )
              ]
            ),
            // Creates a gap between the user information elements
            const SizedBox(height: 10.0),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Creates the email element
                  Text(
                    'Email : jim.bob@student.csulb.edu',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ]
            ),
            // Creates a gap between the user information elements
            const SizedBox(height: 10.0),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Creates the phone number element
                  Text(
                    'Phone Number : 2094143597',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ]
            ),
          ]
        ),
      ),
    );
  }
}