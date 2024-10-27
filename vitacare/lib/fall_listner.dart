import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel("com.yourapp/sos");

void listenForFallEvents() {
  FirebaseFirestore.instance
      .collection('fall_logs')
      .snapshots()
      .listen((snapshot) {
    for (var docChange in snapshot.docChanges) {
      if (docChange.type == DocumentChangeType.added) {
        var data = docChange.doc.data();
        if (data != null && data['status'] == "fall detected") {
          triggerFallSOS(); 
        }
      }
    }
  });
}

void triggerFallSOS() async {
  print("Attempting to trigger fall SOS..."); // Debug log
  try {
    await platform.invokeMethod("fallSOS");
    print("Fall SOS triggered successfully"); // Debug log
  } catch (e) {
    print("Error triggering SOS: $e");
  }
}

