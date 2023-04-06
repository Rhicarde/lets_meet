import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lets_meet/Profile/profile_screen.dart';

import '../Notifications/Notification_Services.dart';
import 'Home.dart';

// Tab Manager manages the indexing and swapping between screens on the navigation bar
class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  _Pages createState() => _Pages();
}

class _Pages extends State<Pages>{
  // Index used to swap between screens on navigation bar
  int _selectedIndex = 1;

  // Possible Screens to swap between
  List<Widget> pages = [
    ShowNotification(),
    Home(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom Navigation Bar used for selecting the pages
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 20
          ),
          child: GNav(
              backgroundColor: Theme.of(context).canvasColor,
              color: Colors.blue,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: (index){
                setState(() {
                  _selectedIndex = index;
                });
                },
              tabs: const [
                GButton(icon: Icons.punch_clock_outlined, text: 'Upcoming'),
                GButton(icon: Icons.home_outlined, text: 'Home'),
                GButton(icon: Icons.settings_outlined, text: 'Settings'),
              ]
          ),
        ),
      ),
      // Displays pages based on current index
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
    );
  }

}