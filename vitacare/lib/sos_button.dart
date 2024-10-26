import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class SOSButton extends StatelessWidget {
  final String emergencyNumber;
  final List<String> emergencyContacts;

  SOSButton({
    required this.emergencyNumber,
    required this.emergencyContacts,
  });

  // Method channel for platform-specific calls
  static const MethodChannel _channel = MethodChannel('com.yourapp/sos');

  // Function to send SMS to multiple contacts
  Future<void> _sendSMS() async {
    for (String contact in emergencyContacts) {
      try {
        print("Attempting to send SMS to: $contact");
        await _channel.invokeMethod('sendSMS', {'number': contact, 'message': 'SOS! I need help!'});
      } catch (e) {
        print("Failed to send SMS to $contact: $e");
      }
    }
  }

  // Function to make a direct call
  Future<void> _makeCall() async {
    try {
      print("Attempting to make a call to $emergencyNumber");
      await _channel.invokeMethod('makeCall', {'number': emergencyNumber});
    } catch (e) {
      print("Failed to make call: $e");
    }
  }

  Future<void> handleSOS() async {
    // Request necessary permissions
    if (await Permission.sms.request().isGranted &&
        await Permission.phone.request().isGranted) {
      // Send SMS and make call
      await _sendSMS();
      await _makeCall();
    } else {
      print("Permissions not granted for SMS and phone calls");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handleSOS(),
      child: Text('SOS'),
    );
  }
}
