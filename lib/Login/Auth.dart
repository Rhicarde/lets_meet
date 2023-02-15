import 'package:flutter/material.dart';

import 'Login.dart';
import 'Register.dart';

// Class used to toggle between Login and Sign Up screens
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // Starts at Login Screen
  bool isLogin = true;

  @override
  // Whenever Sign Up or Sign In button is clicked, screen is toggled
  Widget build(BuildContext context) =>
    isLogin ? Login(onClickedSignUp: toggle)
            : Register(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}