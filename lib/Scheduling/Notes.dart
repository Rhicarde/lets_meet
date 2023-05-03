import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  @override
  _CreateNote createState() => _CreateNote();
}

class _CreateNote extends State<Notes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // creating stream variables
  late CollectionReference _notesRef;
  late Stream<QuerySnapshot> _notesStream;
  String input = "";

  @override
  // initiazling state of widget
  void initState() {
    super.initState();
    _notesRef = _firestore
        .collection("Users")
        .doc(_auth.currentUser?.uid)
        .collection('Schedules')
        .doc("Notes")
        .collection("Notes");
    _notesStream = _notesRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        children: [
          Expanded(
            // builds new listview when data is updated to the collection
            child: StreamBuilder<QuerySnapshot>(
              stream: _notesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    final List<DocumentSnapshot> documents =
                        snapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> data =
                        documents[index].data() as Map<String, dynamic>;
                        final String note = data['Note'];

                        // delete note
                        return Dismissible(
                          key: ValueKey(documents[index].id),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              title: Text(note),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _notesRef.doc(documents[index].id).delete();
                                },
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            _notesRef.doc(documents[index].id).delete();
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
          // add new textfield at the bottom
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "New Note",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final Map<String, dynamic> dataToSave = {
                      'Note': input,
                    };
                    await _notesRef.add(dataToSave);
                    setState(() {
                      input = "";
                    });
                  },
                ),
              ),
              onChanged: (String value) {
                input = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
