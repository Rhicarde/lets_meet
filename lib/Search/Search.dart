import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import '../Database/Schedule Database.dart';
import '../Login/Auth.dart';
import '../Login/ProfileVerification.dart';
import 'DisplaySearch.dart';

//creating the MyHomePage class for the search
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _Search();
}

//connecting the search to the user database
class _Search extends State<Search> {
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
                title: const Text('LetsPlan'),
                searchHintText: 'Search Title',
                foregroundColor: Colors.white,
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.refresh_outlined,
                          size: 26.0,
                        ),
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileVerification())
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.exit_to_app,
                          size: 26.0,
                        ),
                        onTap: () => FirebaseAuth.instance.signOut().then((res) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()),
                          );
                        },
                        ),
                      )
                  )
                ],
                //search based on value constantly updating whenever the user types characters
                onSearch: (value) => setState(() => searchValue = value)
                  ),

            body: Column( //displaying the search based on what is searched
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: DisplaySearch(query:searchValue)),
              ]
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
