import 'package:flutter/material.dart';
import '../Shared/constants.dart';
import 'Register.dart';
import 'VisiblePassword.dart';

class SignIn extends StatefulWidget {

  final Function? toggleView;
  SignIn({this.toggleView});

  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn>{
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool visible = true;

  late String email;
  late String password;

  String error = "";

  void toggleVisibility() {
    setState(() => visible = !visible);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: Theme.of(context).appBarTheme.centerTitle,
            title: const Text('Lets Meet'),
            actions: const <Widget>[]
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: const Text('Sign in', style: TextStyle(fontSize: 20),)
                      ),
                      //Email
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => val!.isEmpty ? "Enter an email" : null,
                          onChanged: (val) {
                            setState (() => email = val);
                          }
                      ),
                      SizedBox(height: 20.0),
                      //Password
                      VisiblePassword(
                          visible: visible,
                          toggleVisibility: toggleVisibility,
                          onChanged: (val) {
                            setState(() => password = val!
                            );
                          }),
                      SizedBox(height: 20.0),
                      //Login button
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                                if (true){
                                  setState(() {
                                    error = 'Your email or password is incorrect. Try again.';
                                    loading = false;
                                  });
                                }
                              }
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account?", style: TextStyle(fontSize: 15),),
                          TextButton(
                              child: const Text('Sign up', style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Register()));
                              })
                        ],
                      )
                    ]
                )
            )
        )
    );
  }
}



