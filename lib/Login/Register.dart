import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Database/Schedule Database.dart';
import 'Authentication/fire_auth.dart';
import 'Authentication/validator.dart';

// Class 'Constructor'
class Register extends StatefulWidget{
  final VoidCallback onClickedSignIn;

  const Register({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  User_Database db = User_Database();

  // Parameters defined to be used later
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Lets Plan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                    children: [
                      // Input Boxes for the Sign Up information
                      Form(
                        key: _registerFormKey,
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text('Create Account',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                              ),
                              const SizedBox(height: 50,),
                              Row(
                                  children: [
                                    const Icon(Icons.person_outline),
                                    const SizedBox(width: 10,),
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: _nameTextController,
                                        focusNode: _focusName,
                                        // Checks for non-empty box
                                        validator: (value) => Validator.validateName(
                                          name: value!,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Name",
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
                                  children: [
                                    const Icon(Icons.mail_outline),
                                    const SizedBox(width: 10,),
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: _emailTextController,
                                        focusNode: _focusEmail,
                                        // Checks for valid email address
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
                              const SizedBox(height: 16.0),
                              Row(
                                  children: [
                                    const Icon(Icons.lock_outline),
                                    const SizedBox( width: 10,),
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: _passwordTextController,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        // Checks for valid/secure password
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
                                  ]
                              ),
                              const SizedBox(height: 32.0),
                              Row(
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
                                      if (_registerFormKey.currentState!.validate()) {
                                        User? user = await FireAuth.registerUsingEmailPassword(
                                          name: _nameTextController.text,
                                          email: _emailTextController.text,
                                          password: _passwordTextController.text,
                                          context: context,
                                          formKey: _registerFormKey,
                                        );
                                        db.createProfile(name: _nameTextController.text, email: _emailTextController.text);
                                        setState(() {});
                                      }
                                    },
                                    child: Row(
                                        children: const [
                                          Text('Sign up',
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: // Text button used to return to Log In screen
                        RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickedSignIn,
                                    text: "Sign In",
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16),
                                  )
                                ]
                            )
                        ),
                      )
                    ]
                ),
              )
            ],
          )
        )
        )
    );
  }
}