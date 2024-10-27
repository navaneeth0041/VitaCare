// // screens/edit_medication_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vitacare/models/medication_model.dart';
// import '../providers/medication_provider.dart';

// class EditMedicationScreen extends StatefulWidget {
//   final DateTime date;
//   final String medicationId;
//   final Medication medication;

//   EditMedicationScreen({required this.date, required this.medicationId, required this.medication});

//   @override
//   _EditMedicationScreenState createState() => _EditMedicationScreenState();
// }

// class _EditMedicationScreenState extends State<EditMedicationScreen> {
//   late TextEditingController _nameController;
//   late TextEditingController _dosageController;
//   late int _frequency;
//   late List<String> _times;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.medication.name);
//     _dosageController = TextEditingController(text: widget.medication.dosage);
//     _frequency = widget.medication.frequency;
//     _times = List<String>.from(widget.medication.times);
//   }

//   void _saveMedication() {
//     final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
//     Medication updatedMedication = Medication(
//       name: _nameController.text,
//       dosage: _dosageController.text,
//       frequency: _frequency,
//       times: _times,
//     );
//     medicationProvider.updateMedication(widget.date, widget.medicationId, updatedMedication);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Medication"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveMedication,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Medication Name"),
//             ),
//             TextField(
//               controller: _dosageController,
//               decoration: InputDecoration(labelText: "Dosage"),
//             ),
//             // Additional input fields for frequency, time selection, etc.
//           ],
//         ),
//       ),
//     );
//   }
// }
