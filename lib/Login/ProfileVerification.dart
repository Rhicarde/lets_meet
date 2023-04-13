import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../Scheduling/Home.dart';
import '../Scheduling/TabManager.dart';
import 'Authentication/fire_auth.dart';

// Class used to check that logged in user has a verified email
class ProfileVerification extends StatefulWidget {
  @override
  _ProfileVerificationState createState() => _ProfileVerificationState();
}

class _ProfileVerificationState extends State<ProfileVerification> {
  // Parameters
  bool _isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Checks for verified email
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // If not verified, sends Email Verification
    if (!_isEmailVerified) {
      sendVerificationEmail();

      // Checks again every 3 seconds
      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  // Function checks if user's email is verified
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // Stops checking if email is verified
    if (_isEmailVerified) timer?.cancel();
  }

  // Sends verification link to user's email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      // Sends a verification code to email every 5 seconds of checking
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  // If email is verified, redirect to Home Screen
  // Else, display email verification screen
  @override
  Widget build(BuildContext context) => _isEmailVerified
          ? Pages()
          : Scaffold(
              appBar: AppBar(
                title: const Text('Verify Email'),
              ),
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
                      tabs: const [
                        GButton(icon: Icons.punch_clock_outlined, text: 'Upcoming'),
                        GButton(icon: Icons.home_outlined, text: 'Home'),
                        GButton(icon: Icons.settings_outlined, text: 'Settings'),
                      ]
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A verification email has been sent to your email',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24,),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      icon: Icon(Icons.email, size: 32),
                      label: const Text('Resend Email',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                    ),
                    const SizedBox(height: 8,),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      child: const Text('Cancel',
                        style: TextStyle(fontSize: 24)
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    )
                  ],
                ),
              ),
            );
}