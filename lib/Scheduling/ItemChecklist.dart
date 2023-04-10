import 'package:flutter/material.dart';

class ItemChecklist extends StatefulWidget {
  @override
  _ItemChecklistState createState() => _ItemChecklistState();
}

class _ItemChecklistState extends State<ItemChecklist> {

  // Creates a list for the checklist items and their associated boolean values (checklist)
  List<String> listItems = [];
  List<bool> listCheck = [];

  // Creates the text boxes for typing in item names
  final TextEditingController eCtrl = TextEditingController();
  final TextEditingController _textFieldController =
  TextEditingController();

  // Builds the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Checklist"),
      ),
      body: Column(
        children: <Widget>[
          // Creates the Textbox UI
          TextField(
            controller: eCtrl,
            onSubmitted: (text) {
              // Once an item name is submitted, it is added to the list and given a default
              // value of false
              // The Textbox is cleared after submission
              setState(() {
                listItems.insert(0, text);
                listCheck.add(false);
                eCtrl.clear();
              });
            },
          ),
          Expanded(
            // Creates the UI For the list of items
            child: ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (BuildContext context, int index) {
                // Creates a gesture reader, which renames a value on long press
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('TextField in Dialog'),
                          content: TextField(
                            controller: _textFieldController,
                            decoration: InputDecoration(
                                hintText: "${listItems[index]}"),
                          ),
                          actions: <Widget>[
                            // Creates the button for edit confirmation
                            // If you press 'Done', the item chosen will be renamed to the new input
                            TextButton(
                              child: Text('Done'),
                              onPressed: () {
                                setState(() {
                                  listItems[index] =
                                      _textFieldController.text;
                                  _textFieldController.clear();
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  // Creates a checkbox with a value and boolean stored in the lists above
                  child: ListTile(
                    leading: Checkbox(
                      value: listCheck[index],
                      // When you touch the checkbox, its value is flipped
                      onChanged: (value) {
                        setState(() {
                          listCheck[index] = !listCheck[index];
                        });
                      },
                    ),
                    title: Text(listItems[index]),
                    // Creates an icon at the far right of each item
                    // The icon will remove the given item when pressed
                    // The item is removed from the UI and the list data structure
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          listItems.removeAt(index);
                          listCheck.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
