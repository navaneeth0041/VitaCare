// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:telephony/telephony.dart';

// class SosProvider with ChangeNotifier {
//   final String primaryContactNumber = '8075911824';
//   final List<String> emergencyContacts = ['8075911824'];

//   final Telephony telephony = Telephony.instance;

//   Future<void> initiateSos() async {
//     await FlutterPhoneDirectCaller.callNumber(primaryContactNumber);

//     for (var contact in emergencyContacts) {
//       telephony.sendSms(to: contact, message: 'This is an SOS alert! Immediate assistance is required.');
//     }
//   }
// }
