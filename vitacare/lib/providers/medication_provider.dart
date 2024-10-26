import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/medication_model.dart';

class MedicationProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Medication> medications = [];

  Future<void> fetchMedications(DateTime date) async {
    QuerySnapshot snapshot = await firestore
        .collection('medication_log')
        .where('date', isEqualTo: date)
        .get();

    medications = snapshot.docs.map((doc) {
      return Medication.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    notifyListeners();
  }

Future<void> addMedication(Medication medication, File? image) async {
  DocumentReference docRef = firestore.collection('medication_log').doc();
  String imageUrl = '';

  if (image != null) {
    TaskSnapshot uploadTask = await storage
        .ref('medications/${docRef.id}.jpg')
        .putFile(image);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }

  medication.imageUrl = imageUrl;
  await docRef.set(medication.toMap());
  medications.add(medication);
  notifyListeners();
}

}
