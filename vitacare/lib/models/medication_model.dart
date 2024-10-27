import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  String id;
  String name;
  String frequency;
  DateTime date;
  String imageUrl;
  List<String> reminders; // Option 1: Store reminders as List of time strings
  String type;

  Medication({
    required this.id,
    required this.name,
    required this.frequency,
    required this.date,
    required this.imageUrl,
    required this.reminders, // Use this for Option 1
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'date': date,
      'imageUrl': imageUrl,
      'reminders': reminders, // Store reminders as list of strings
      'type': type,
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      frequency: map['frequency'],
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      reminders: List<String>.from(map['reminders']), // Option 1
      type: map['type'],
    );
  }
}
