import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar_Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;

  const Calendar_Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type
  });


  factory Calendar_Event.fromPlanFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'self_plan',
    );
  }

  factory Calendar_Event.fromEventFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'self_event',
    );
  }

  factory Calendar_Event.fromOtherPlanFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'other_plan',
    );
  }

  factory Calendar_Event.fromOtherEventFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'other_event',
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "title": title,
      "description": description,
      "time": Timestamp.fromDate(date),
      "type": type,
    };
  }
}