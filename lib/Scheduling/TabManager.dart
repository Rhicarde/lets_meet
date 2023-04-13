import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lets_meet/Notifications/DisplayUpcoming.dart';
import 'package:lets_meet/Profile/profile_screen.dart';
import '../Home/Home.dart';

// Tab Manager manages the indexing and swapping between screens on the navigation bar
class Pages extends StatefulWidget {
  const Pages({Key? key,}) : super(key: key);

  @override
  _Pages createState() => _Pages();
}

class _Pages extends State<Pages>{
  // Index used to swap between screens on navigation bar
  int _selectedIndex = 1;

  // Possible Screens to swap between
  List<Widget> pages = const [
    DisplayUpcoming(),
    Home(),
    ProfileScreen(),
    // Verification(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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


//
// class Verification extends StatefulWidget {
//   const Verification({Key? key,}) : super(key: key);
//
//   @override
//   _Verification createState() => _Verification();
// }
//
// class _Verification extends State<Verification> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify Email'),
//       ),
//       bottomNavigationBar: Container(
//         color: Theme.of(context).canvasColor,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 15, vertical: 20
//           ),
//           child: GNav(
//               backgroundColor: Theme.of(context).canvasColor,
//               color: Colors.blue,
//               activeColor: Colors.white,
//               tabBackgroundColor: Colors.blue,
//               padding: const EdgeInsets.all(16),
//               gap: 8,
//               tabs: const [
//                 GButton(icon: Icons.punch_clock_outlined, text: 'Upcoming'),
//                 GButton(icon: Icons.home_outlined, text: 'Home'),
//                 GButton(icon: Icons.settings_outlined, text: 'Settings'),
//               ]
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'A verification email has been sent to your email',
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24,),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size.fromHeight(50),
//               ),
//               icon: Icon(Icons.email, size: 32),
//               label: const Text('Resend Email',
//                 style: TextStyle(fontSize: 24),
//               ),
//               onPressed: canResendEmail ? sendVerificationEmail : null,
//             ),
//             const SizedBox(height: 8,),
//             TextButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size.fromHeight(50),
//               ),
//               child: const Text('Cancel',
//                   style: TextStyle(fontSize: 24)
//               ),
//               onPressed: () => FirebaseAuth.instance.signOut(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }