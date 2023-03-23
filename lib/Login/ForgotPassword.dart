import 'package:flutter/material.dart';

import 'Auth.dart';
import 'Authentication/fire_auth.dart';
import 'Authentication/validator.dart';

// Screen for user to reset password
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  // Widgets to build screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: const Text('Lets Plan'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text('Forgot Password',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(Icons.email_outlined),
                              const SizedBox(width: 10,),
                              // Creating textbox to input user email
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _emailTextController,
                                  validator: (value) => Validator.validateEmail(
                                    email: value!,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter Email",
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
                          // Submit email for password reset
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    )
                                )
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await FireAuth.resetPassword(
                                    email: _emailTextController.text,
                                    context: context);
                              }
                              // Returns to login screen
                              Navigator.of(context).pop(); //pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
                            },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                            Text('Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10,),
                            Icon(Icons.arrow_forward),
                          ]
                      ),
                          )

                        ],
                      ),
                    ),
                  ]
              ),
            )
        )
    );
  }
}