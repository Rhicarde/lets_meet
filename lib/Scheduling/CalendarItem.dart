import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Calendar_Event.dart';


class CalendarItem extends StatelessWidget {
  final Calendar_Event schedule;
  const CalendarItem({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        schedule.title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: getCodeColor(schedule)),
      ),
      subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text(schedule.description,
              style: TextStyle(fontSize: 16)
          ),
          SizedBox(height: 10,),
          Text(DateFormat('MMMM dd, yyyy').format(schedule.date),
              style: TextStyle(fontSize: 16),
          )
        ]
      )
    );
  }

  Color getCodeColor(dynamic e){
    switch (e.type) {
      case 'self_plan':
        return Colors.blue;
      case 'self_event':
        return Colors.blue;
      case 'other_plan':
        return Colors.yellow;
      case 'other_event':
        return Colors.yellow;
    }
    return Colors.black;
  }
}