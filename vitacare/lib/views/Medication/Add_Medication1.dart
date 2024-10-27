import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitacare/views/Medication/manualentrymedication.dart';
import 'dart:io';
import '../../../models/medication_model.dart';
import '../../../providers/medication_provider.dart';

class AddMedication extends StatefulWidget {
  final DateTime date;

  AddMedication({required this.date});

  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
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

  }

  void _navigateToManualSetup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManualMedicationEntryScreen(date: widget.date),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.06),
              Text(
                'Add Medication',
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: screenWidth * 0.06),
              Text(
                'You can either manually add medication or let our AI set it up based on your data.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              SetupOption(
                icon: Icons.camera_alt,
                color: Colors.blueAccent,
                title: 'Scan with AI',
                description: 'Set up medication intuitively',
                onTap: _pickImage,
              ),
              SizedBox(height: screenWidth * 0.1),
              SetupOption(
                icon: Icons.edit,
                color: Colors.green,
                title: 'Manually Set Up',
                description: 'Enter medication details',
                onTap: _navigateToManualSetup,
              ),
              SizedBox(height: screenHeight*0.09,),
              GestureDetector(
                onTap: _saveMedication,
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
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final VoidCallback onTap;

  const SetupOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, size: screenWidth * 0.1, color: color),
            SizedBox(height: screenWidth * 0.02),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            SizedBox(height: screenWidth * 0.015),
            Text(
              description,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
