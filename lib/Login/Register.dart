import 'package:flutter/material.dart';
import '../Shared/constants.dart';
import 'Login.dart';
import 'VisiblePassword.dart';

class Register extends StatefulWidget{

  final Function? toggleView;
  const Register({this.toggleView});

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  late String email;
  late String password;
  String error = '';
  bool _obscured = true;


  RegExp number = RegExp(r".*[0-9].*");
  RegExp capital =  RegExp(r".*[A-Z].*");
  RegExp lower =  RegExp(r".*[a-z].*");
  RegExp special =  RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  String? lengthError;
  String? numberError;
  String? capitalError;
  String? lowerError;
  String? specialError;

  List<Widget> errors =[];

  bool isPasswordCompliant(String? pass, [int minLength = 10]) {
    if (pass == null || pass.isEmpty) {
      return false;
    }

    bool hasUppercase = capital.hasMatch(pass);
    bool hasDigits = number.hasMatch(pass);
    bool hasLowercase = lower.hasMatch(pass);
    bool hasSpecialCharacters = special.hasMatch(pass);
    bool hasMinLength = password.length > minLength;

    errors = List.empty(growable: true);

    if(!hasMinLength) {
      errors.add(Text(lengthError?? ""));
    }
    if(!hasDigits) {
      errors.add(Text(numberError ?? ""));
    }
    if(!hasUppercase) {
      errors.add(Text(capitalError ?? ""));
    }
    if(!hasLowercase) {
      errors.add(Text(lowerError ?? ""));
    }
    if(!hasSpecialCharacters) {
      errors.add(Text(specialError ?? ""));
    }

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  }


  void checkPasswordErrors(String? pass){

    lengthError = pass!.length < 10
        ? "Password length should be at least 10"
        : null;
    numberError = !number.hasMatch(pass)
        ? "Password must contain digits 0 - 9"
        : null;
    capitalError = !capital.hasMatch(pass)
        ? "Password must contain a capital letter"
        : null;
    lowerError = !lower.hasMatch(pass)
        ? "Password must contain lowercase letters"
        : null;
    specialError = !special.hasMatch(pass)
        ? "Password must contain a special character"
        : null;

  }

  void toggleVisibility(){
    setState(()=> _obscured = !_obscured);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: Theme.of(context).appBarTheme.centerTitle,
          title: Text('Lets Meet'),
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
                          child: const Text('Sign up', style: TextStyle(fontSize: 20),)
                      ),
                      //Username
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => val!.isEmpty ? "Enter an email" : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }
                      ),
                      SizedBox(height: 20.0),
                      //Password
                      VisiblePassword(
                          visible: _obscured,
                          toggleVisibility: toggleVisibility,
                          validator: ((pass){
                            if (!isPasswordCompliant(pass)) {
                              setState((){
                                checkPasswordErrors(pass);
                              });
                              return "Password is not compliant.";
                            }
                            return null;
                          }),
                          onChanged: (val) {
                            setState(() => password = val!);
                          }
                      ),
                      Column(
                          children: errors
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                                if (true){
                                  setState(() {
                                    error = 'Please supply a valid email';
                                    loading = false;
                                  });
                                }
                              }
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already Registered?", style: TextStyle(fontSize: 15),),
                          TextButton(
                              child: const Text('Sign in', style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
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