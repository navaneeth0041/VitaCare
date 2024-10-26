import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  String id;
  String name;
  String frequency;
  DateTime date;
  String imageUrl;
  List<String> reminders;

  Medication({
    required this.id,
    required this.name,
    required this.frequency,
    required this.date,
    required this.imageUrl,
    required this.reminders,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'date': date,
      'imageUrl': imageUrl,
      'reminders': reminders,
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      frequency: map['frequency'],
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'],
      reminders: List<String>.from(map['reminders']),
    );
  }
}
