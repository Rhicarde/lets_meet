import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Login/Authentication/validator.dart';
import 'package:lets_meet/Login/ProfileVerification.dart';
import '../Home/Home.dart';
import 'Authentication/fire_auth.dart';
import 'ForgotPassword.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Login({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  _Login createState() => _Login();
}

// Login Screen
class _Login extends State<Login>{

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  // Boolean used for login
  bool _isProcessing = false;

  // Retrieves database information
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    // Retrieves user information
    User? user = FirebaseAuth.instance.currentUser;

    // Checks if user is logged in or not
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        // If logged in, display Home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileVerification(),
          ),
        );
      }
     }
    );
    return firebaseApp;
  }

  // Widgets to build Login Screen
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
    },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Lets Plan'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                // Contains textboxes and buttons
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Form(
                          key: _formKey,
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Displays Logo
                                  const Image(image: AssetImage('lib/Images/LetsPlan-border.png'), width: 200,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.mail_outline),
                                        const SizedBox(width: 10,),
                                        // Email Textbox
                                        SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            controller: _emailTextController,
                                            focusNode: _focusEmail,
                                            validator: (value) => Validator.validateEmail(
                                              email: value!,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Email",
                                              border: InputBorder.none,
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(6.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.lock_outline),
                                        const SizedBox(width: 10,),
                                        // Password Textbox
                                        SizedBox(
                                          width: 225,
                                          child: TextFormField(
                                            controller: _passwordTextController,
                                            focusNode: _focusPassword,
                                            obscureText: true,
                                            validator: (value) => Validator.validatePassword(
                                              password: value!,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Password",
                                              border: InputBorder.none,
                                              errorBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(6.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        // Textbutton that redirects to ForgotPassword screen
                                        GestureDetector(
                                          child: Text('Forgot',
                                              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16)
                                          ),
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())),
                                        ),
                                      ]
                                  ),
                                  // Login Button
                                  const SizedBox(height: 20.0),
                                  _isProcessing
                                      ? const CircularProgressIndicator()
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            minimumSize: MaterialStateProperty.all<Size>(
                                                const Size(150,50)
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                )
                                            )
                                        ),
                                        onPressed: () async {
                                          _focusEmail.unfocus();
                                          _focusPassword.unfocus();

                                          if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              _isProcessing = true;
                                            });

                                            User? user = await FireAuth.signInUsingEmailPassword(
                                              email: _emailTextController.text,
                                              password: _passwordTextController.text,
                                              context: context,
                                            );
                                            setState(() {
                                              _isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileVerification(),),);
                                            }
                                          }
                                        },
                                        child: Row(
                                            children: const [
                                              Text('Login',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              SizedBox(width: 10,),
                                              Icon(Icons.arrow_forward),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Textbox to allow for sign ups at the bottom of the screen
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: RichText(
                                text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                    children: [
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = widget.onClickedSignUp,
                                        text: "Sign Up",
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16),
                                      )
                                    ]
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
