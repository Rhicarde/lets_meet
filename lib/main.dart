import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lets_meet/Login/ProfileVerification.dart';
import 'Login/Auth.dart';
import 'Login/Authentication/fire_auth.dart';

// App Initializer
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Loads up app's main page on startup
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        title: "Lets Plan",
        home: MainPage()
  );
}

// MainPage will decide which screen will be shown to the user
// Home / Email Verification Screen if logged in, Login or Sign Up Screen otherwise
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Displays loading symbol while connection is made
              return const Center(child: CircularProgressIndicator());
              // Checks for errors
            } else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong!"));
              // If there is data, the user is logged in -> changes to new screen
            } else if (snapshot.hasData) {
              return ProfileVerification();
            } else {
              // User does not have account -> Display Login/Sign Up screen
              return Auth();
            }
          },
      )
    );
}