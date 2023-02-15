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
                          TextFormField(
                            controller: _emailTextController,
                            validator: (value) => Validator.validateEmail(
                              email: value!,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                            ),
                            icon: Icon(Icons.email_outlined),
                            label: Text('Reset Password',
                              style: TextStyle(fontSize: 24),),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await FireAuth.resetPassword(
                                    email: _emailTextController.text,
                                    context: context);
                              }
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
                            }
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