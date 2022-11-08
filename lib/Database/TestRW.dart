import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class User_Database {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  void add_note({required String body, required String title}) {
    users.doc('R_Huynh')
        .collection('Notes').doc('Note-01')
        .set({'body': body, 'title': title});
  }

   getNotes() {
    return users.doc('R_Huynh')
        .collection('Notes').snapshots();
  }
}