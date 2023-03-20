import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OptimalDeparture extends StatefulWidget{
  _OptimalDeparture createState() => _OptimalDeparture();
}


//TODO: get all users of an event
class _OptimalDeparture extends State<OptimalDeparture>{
  Widget build(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

  }
}

