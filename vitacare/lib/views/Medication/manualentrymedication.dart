import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vitacare/models/medication_model.dart';
import 'package:vitacare/providers/medication_provider.dart';


class ManualMedicationEntryScreen extends StatefulWidget {
  final DateTime date;

  const ManualMedicationEntryScreen({Key? key, required this.date}) : super(key: key);

  @override
  _ManualMedicationEntryScreenState createState() => _ManualMedicationEntryScreenState();
}

class _ManualMedicationEntryScreenState extends State<ManualMedicationEntryScreen> {
  String _medicineName = '';
  String _type = 'Pill';
  int _dosage = 1;
  int _duration = 14;
  TimeOfDay _selectedTime = TimeOfDay.now();
  late DateTime _selectedDate;
  String _selectedFrequency = 'Daily';
  final List<String> _frequencies = ['Daily', 'Weekly', 'Alternative'];
  final List<String> _types = ['Pill', 'Liquid', 'Injection'];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

Future<void> _addMedication() async {
  if (_medicineName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a medicine name')),
    );
    return;
  }

  try {
    // Prepare Medication model
    final medication = Medication(
      id: '', // Firestore generates the ID
      name: _medicineName,
      frequency: _selectedFrequency,
      date: _selectedDate,
      imageUrl: '',
      reminders: [_selectedTime.format(context)], // Single reminder for now
      type: _type,
    );

    // Upload the image if selected
    String? imageUrl;
    if (_selectedImage != null) {
      final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
      imageUrl = await medicationProvider.uploadImage(_selectedImage!);
      medication.imageUrl = imageUrl; // Set imageUrl in Medication model
    }

    // Add medication with image URL to Firestore
    await Provider.of<MedicationProvider>(context, listen: false).addMedication(medication, null);

    Navigator.of(context).pop(); // Go back after adding
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding medication: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medication"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Medication',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField('Medicine Name', (value) => _medicineName = value),
              SizedBox(height: 20),
              _buildDosageAndDuration(),
              SizedBox(height: 20),
              _buildDatePicker(),
              SizedBox(height: 20),
              _buildTimePicker(),
              SizedBox(height: 20),
              _buildFrequencyDropdown(),
              SizedBox(height: 20),
              _buildTypeDropdown(),
              SizedBox(height: 20),
              _buildImagePicker(),
              SizedBox(height: 30),
              _buildAddButton(screenWidth),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAddButton(double screenWidth) {
    return GestureDetector(
      onTap: _addMedication,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Medicine',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDosageAndDuration() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _dosage,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Dosage',
            ),
            items: [1, 2, 3]
                .map((e) => DropdownMenuItem(value: e, child: Text('$e Pill(s)')))
                .toList(),
            onChanged: (value) => setState(() => _dosage = value!),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _duration,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Duration',
            ),
            items: [7, 14, 21, 28]
                .map((e) => DropdownMenuItem(value: e, child: Text('$e day(s)')))
                .toList(),
            onChanged: (value) => setState(() => _duration = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text('Date: ${_selectedDate.toLocal().toIso8601String().split('T')[0]}'),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      title: Text('Time: ${_selectedTime.format(context)}'),
      trailing: Icon(Icons.access_time),
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );
        if (pickedTime != null) {
          setState(() {
            _selectedTime = pickedTime;
          });
        }
      },
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFrequency,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Frequency',
      ),
      items: _frequencies.map((frequency) {
        return DropdownMenuItem<String>(
          value: frequency,
          child: Text(frequency),
        );
      }).toList(),
      onChanged: (value) => setState(() {
        _selectedFrequency = value!;
      }),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _type,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Type',
      ),
      items: _types.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) => setState(() {
        _type = value!;
      }),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attach Image (optional)', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _pickImage,
          child: _selectedImage != null
              ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover)
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add_a_photo, color: Colors.grey[800]),
                ),
        ),
      ],
    );
  }
}



 