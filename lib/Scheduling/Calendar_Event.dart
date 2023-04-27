import 'package:cloud_firestore/cloud_firestore.dart';

// Takes database reads and converts to usable constructor
class Calendar_Event {
  final String title;
  final String description;
  final DateTime date;
  late final String type;

  Calendar_Event({
    required this.title,
    required this.description,
    required this.date,
    required this.type
  });

  // Takes database snapshot plans and creates Calendar Event object using its data
  factory Calendar_Event.fromPlanFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'self_plan',
    );
  }

  // Takes database snapshot events and creates Calendar Event object using its data
  factory Calendar_Event.fromEventFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'self_event',
    );
  }

  // Takes compared user's database snapshot plans and creates Calendar Event object using its data
  factory Calendar_Event.fromOtherPlanFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'other_plan',
    );
  }
  // Takes compared user's database snapshot events and creates Calendar Event object using its data
  factory Calendar_Event.fromOtherEventFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Calendar_Event(
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: 'other_event',
    );
  }

  // Constructor Getter
  Map<String, Object?> toFirestore() {
    return {
      "title": title,
      "description": description,
      "time": Timestamp.fromDate(date),
      "type": type,
    };
  }

  // Setter for object type param
  setType(String type) {
    this.type = type;
  }
}