import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_Database {
  // Users Collection in the Database
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // Kieran King
  // Given a day and time, finds the beginning of the following day
  DateTime getBeginningOfNextDay(DateTime inputDate) {
    print(DateUtils.dateOnly(inputDate).add(const Duration(days: 1)).toString());
    return DateUtils.dateOnly(inputDate).add(const Duration(days: 1));
  }

  // Write to database - Notes are the plans created by the users
  // Contains: title, description, time, reminder, and repeat
  void add_note({required String description, required bool remind, required bool repeat, required String title, required DateTime date}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .add({'description': description, 'remind': remind, 'repeat': repeat, 'title': title, 'date': date, 'titleSearch': titleSearchParam(title: title), 'completed': false});
    }
  }

  // Writes to database, Creates a new event
  // Contains: title, description, location, remind, repeat, comments, date, time, and userIds
  void add_event({required String title, required String description, required String location, required bool remind, required bool repeat, required List<String> comments, required DateTime date, required String time, required List<String> userIds}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      print('Adding');
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('Event')
          .add({'title': title, 'description': description, 'date': date, 'time': time, 'location': location, 'repeat': repeat, 'remind': remind, 'comments': comments, 'userIds': userIds, 'titleSearch': titleSearchParam(title: title)});
    }
  }

  // Breaks down the title by character in order to be used for search
  titleSearchParam({required String title}) {
    title = title.toLowerCase();

    // List of words allow for search in between title
    List words = title.split(' ');

    List<String> titleSearchList = [];

    while (words.isNotEmpty) {
      String word = mergeTitle(words: words);
      String temp = "";
      for (int i = 0; i < word.length; i++){
        temp = temp + word[i];
        titleSearchList.add(temp);
      }
      words.removeAt(0);
    }

    return titleSearchList;
  }

  // merges List<String> into one string
  mergeTitle({required List words}) {
    String word = '';

    for (int i = 0; i < words.length; i++) {
      word += words[i];

      if (i != words.length){
        word += " ";
      }
    }

    return word;
  }

  // Get the plan titles based on the user's search query
  getSearch({required String query}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    query = query.toLowerCase();
    if (user != null) {
      print(query);

      return users.doc(user.uid)
          .collection('Schedules').doc('Plan').collection('Plans')
          .where("titleSearch", arrayContains: query).snapshots(); //making sure that the title contains what is searched
      }
    }

  //getting the event titles based on the user's search query
  getEventSearch({required String query}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    query = query.toLowerCase();
    if (user != null) {
      print(query);

      return users.doc(user.uid)
          .collection('Schedules').doc('Event').collection('Event')
          .where("titleSearch", arrayContains: query).snapshots(); //making sure that the title contains what is searched
    }
  }

  // Sets plan to completed
  complete_plan({required String id, required bool completion}){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .doc(id).update({'completed': completion});
    }
  }

  // Started by Richard Huynh, but worked on by Kieran King
  // Read from Database - Displays all user plans on home page based on selected date
  getNotes(DateTime planTime) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .where('date', isGreaterThanOrEqualTo: planTime)
          .where('date', isLessThan: getBeginningOfNextDay(planTime))
          .snapshots();
    }
  }

  // Deleted plan from database
  void remove_plan({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Plan').collection('Plans')
          .doc(id).delete();
    }
  }

  // On account creation, write name and email to account as profile information
  void createProfile({required String name, required String email}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      print("Writing to Profile");
      users.doc(user.uid).set({'name': name, 'uid': user.uid});

      users.doc(user.uid)
          .collection('Profile').add({'name': name, 'email': email});
    }
  }

  // Reads user profile from database - returns name and email
  getUserInfo() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Profile').snapshots();
    }
  }

  // Kieran King
  // Creates a list of all app users' ids
  getAllUsers() {
    return users.snapshots();
  }

  // Return all created events that will occur in the future
  get_upcoming_Events({required DateTime date}){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid)
          .collection('Schedules').doc('Event')
          .collection('Event')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date)).snapshots();
    }
  }

  // Return all created plans that will occur in the future
  get_upcoming_Plans({required DateTime date}){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid)
          .collection('Schedules').doc('Plan')
          .collection('Plans')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date)).snapshots();
    }
  }

  // Kieran King
  // Queries and returns a stream of events for a specific given day for the user
  getEvents(DateTime eventDate){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(eventDate))
          .where('date', isLessThan: Timestamp.fromDate(getBeginningOfNextDay(eventDate)))
          .snapshots();
    }
  }

  // Retrieves invited events in the form of an event so that its data can be read/displayed
  getInvitedEvents(DateTime eventDate) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      QuerySnapshot invitedSnapshot = await users.doc(user.uid).collection('Schedules').doc('Event').collection('InvitedEvents')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(eventDate))
          .where('date', isLessThan: Timestamp.fromDate(getBeginningOfNextDay(eventDate))).get();

      List<DocumentReference> invitedEvents = [];

      invitedSnapshot.docs.forEach((doc) async {
        var temp = await users.doc(doc.get('userId')).collection('Schedules').doc('Event').collection('Event').doc(doc.get('eventId'));
        invitedEvents.add(temp);
      });

      return invitedEvents;
    }
  }

  // Kieran King
  // Creates a document with the given event id and the owner of the event's
  // user ID for easy invitation implementation in the future
  void addEventuser({required String eventId, required String userId, required Timestamp eventDate}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // If their is a user currently logged in, add a new document for an
    // event the user was invited to
    if (user != null) {
      users.doc(userId)
          .collection('Schedules')
          .doc('Requests')
          .collection('Requests')
          .add({'eventId': eventId, 'userId': user.uid, 'eventDate': eventDate});
    }
  }

  // Deletes event from database and removes it from all invited users
  void remove_event({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('Event').doc(id).get().then((value) async {
            List<String> invitedUsers = value.get('userIds');
            for (String i in invitedUsers) {
              var collection = await users.doc(i).collection('Schedule').doc('Event').collection('InvitedEvents').where('eventId' == id).get();
               for (var doc in collection.docs) {
                 await doc.reference.delete();
               }
            }
      });
      
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('Event')
          .doc(id).delete();
    }
  }

  // If user deleted an event that they are invited to, remove event and the user from event's invited list
  Future<void> remove_invited_event({required String userId, required String eventId, required String id}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

      List<dynamic> usersList = qSnapshot.get('userIds');

      if (usersList.isNotEmpty) {
        int index = usersList.indexWhere((element) => element == user.uid);
        usersList.removeAt(index);
      }

      users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).update({'userIds': usersList});

      users.doc(user.uid)
          .collection('Schedules')
          .doc('Event').collection('InvitedEvents')
          .doc(id).delete();
    }
  }

  // Checks for any event invitation requests
  checkRequests() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Requests').snapshots();
    }
  }

  // Checks for any Compare Schedule requests
  checkCompareRequests() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Compares').snapshots();
    }
  }

  // Checks if invitee has accepted request
  checkAcceptCompare() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null){
      return users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Accepted Compare').snapshots();
    }
  }

  // If invited event accept, add event and update event invited list
  void add_request({required QueryDocumentSnapshot request}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Accepted");
     users.doc(user.uid)
         .collection('Schedules')
         .doc('Event').collection('InvitedEvents').add({'userId': request.get('userId'), 'eventId': request.get('eventId'), 'eventDate': request.get('eventDate')});

      update_event_invitation(userId: request.get('userId'), eventId: request.get('eventId'));
      remove_request(id: request.id);
    }
  }

  // Updates event invitee list
  update_event_invitation({required String userId, required String eventId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Event Invitees List Being Updated");
      DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

      List<dynamic> usersList = qSnapshot.get('userIds');

      if (usersList.isNotEmpty) {
        if (usersList[0] == "") {
          usersList[0] == user.uid;
        }
      }
      else {
        Set<dynamic> usersSet = usersList.toSet();
        usersSet.add(user.uid);
        usersList = usersSet.toList();
      }

      users.doc(userId)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).update({'userIds': usersList});
    }
  }

  // Deletes event request
  remove_event_invitation({required String userId, required String eventId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Event Invitees List Being Updated");
      DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(user.uid)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

      List<dynamic> usersList = qSnapshot.get('userIds');

      if (usersList.isNotEmpty) {
        int index = usersList.indexWhere((element) => element == userId);
        usersList.removeAt(index);
      }

      users.doc(user.uid)
          .collection('Schedules').doc('Event').collection('Event').doc(eventId).update({'userIds': usersList});
    }
  }

  // Deleted request after completion
  void remove_request({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Removed");
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Requests')
          .doc(id).delete();
    }
  }

  // Creates request to compare schedule
  void compare_request({required String userId, required int month}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // If their is a user currently logged in, add a new document for an
    // event the user was invited to
    if (user != null) {
      users.doc(userId)
          .collection('Schedules')
          .doc('Requests')
          .collection('Compares')
          .add({'userId': user.uid, 'month': month});
    }
  }

  // If request accepted, send accept request
  // Then, delete request
  void accept_compare_request({required QueryDocumentSnapshot request}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Accepted");
      users.doc(request.get('userId'))
          .collection('Schedules')
          .doc('Requests').collection('Accepted Compare').add({'userId': user.uid, 'month': request.get('month')});

      remove_request(id: request.id);
    }
  }

  // Deletes request
  void remove_compare_request({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Removed");
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Compares')
          .doc(id).delete();
    }
  }

  // Deletes request
  void remove_accepted_compare_request({required String id}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("Request Removed");
      users.doc(user.uid)
          .collection('Schedules')
          .doc('Requests').collection('Accepted Compare')
          .doc(id).delete();
    }
  }

  // Converts userId to Name
  get_user_name({required String userId}) async {
    QuerySnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId).collection('Profile').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapshot = qSnapshot.docs;

    Map<String, dynamic>? data = listSnapshot[0].data();

    return data["name"];
  }

  // Converts eventId to event name
  get_event_name({required String userId, required String eventId}) async {
    DocumentSnapshot<Map<String, dynamic>> qSnapshot = await users.doc(userId).collection('Schedules').doc('Event').collection('Event').doc(eventId).get();

    return qSnapshot.get('title');
  }

  // Retrieves event date
  getDate(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return users.doc(user.uid)
          .collection('Schedules').doc("Event").collection("Event").snapshots();
    }
  }

  // Gets all events to display
  get_event({required String eventId}) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if(user != null){
      return users.doc(user.uid).collection('Schedules').doc('Event').collection('Event').doc(eventId).snapshots();
    }
  }
}