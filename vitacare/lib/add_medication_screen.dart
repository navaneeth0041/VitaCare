import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/medication_model.dart';
import '../providers/medication_provider.dart';

class AddMedicationScreen extends StatefulWidget {
  final DateTime date;

  AddMedicationScreen({required this.date});

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _frequencyController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveMedication() {
    final newMedication = Medication(
      id: DateTime.now().toString(),
      name: _nameController.text,
      frequency: _frequencyController.text,
      date: widget.date,
      imageUrl: '', // This will be updated after image upload
      reminders: [],
    );

    Provider.of<MedicationProvider>(context, listen: false)
        .addMedication(newMedication, _selectedImage)
        .then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Medication")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Medication Name"),
            ),
            TextField(
              controller: _frequencyController,
              decoration: InputDecoration(labelText: "Frequency"),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo),
              label: Text("Upload Image"),
            ),
            _selectedImage == null
                ? Text("No image selected")
                : Image.file(_selectedImage!),
            Spacer(),
            ElevatedButton(
              onPressed: _saveMedication,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
