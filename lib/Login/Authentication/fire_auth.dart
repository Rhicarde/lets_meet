import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// Class used to authenticate user registration/logins
class FireAuth {
  // Email-Password Registration
  // Required Registration Parameters: name, email, password
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
    required formKey
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final isValid = formKey.currentState!.validate();
    if (!isValid) return null;

    // Loading Circle until registration is complete
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try {
      // Attempt to authenticate using given email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Retrieves user credential
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();

      // Authenticate user credential
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      // Catch Errors
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // Display Error to User
      Utils.showSnackBar(e.message);
    } catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return user;
  }

  // Email-Password Sign In
  // Required Sign In Parameters: email, password
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    // Loading Circle until Login Authentication completes
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
    );
    // Attempt to log in with given user input
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Displays Errors for failed Logins
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
      // Displays Error to user
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return user;
  }

  // Allows users to resetPassword
  // Required Password Parameters: email
  static Future resetPassword ({
    required String email,
    required BuildContext context,
  }) async {

    // Displays Circle Loading while email is sent
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Utils.showSnackBar("Password Reset Email Sent");
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      // Displays notification to user
      Utils.showSnackBar(e.message);
    }
  }

  // Reloads User object for updated information
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}

// Class used to display error messages to user's display
class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  // Takes in text to display
  static showSnackBar(String? text) {
    if (text == null) return;

    // Snackbar content: text message and color
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red,);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}