import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import '../Database/Schedule Database.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

//creating the MyHomePage class for the search
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//connecting the search to the user database
class _MyHomePageState extends State<MyHomePage> {
  User_Database db = User_Database();

  //final _titleTextController = TextEditingController();

  //initialize search value
  String searchValue = '';

  //Future<QuerySnapshot>? myListSuggest;

  //creating the getter for the query
  get query => null;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
            appBar: EasySearchBar( //creating the search bar which takes in user input
                title: const Text('Search'),
                //search based on value constantly updating whenever the user types characters
                onSearch: (value) => setState(() => searchValue = value)
                  ),

            body: Column( //displaying the search based on what is searched
              children: [Expanded(
                    child: DisplaySearch(query:searchValue)),]
            ),
            /*
            drawer: Drawer(
                child: ListView(
                      ListTile(
                          title: const Text('Item 1'),
                          onTap: () => Navigator.pop(context)
                      ),
                      ListTile(
                          title: const Text('Item 2'),
                          onTap: () => Navigator.pop(context)
                      )
                    ]
                )
            ),
             */
            //body: Center(
                //child: Text('Value: $searchValue')
            //)
        );
  }
}
