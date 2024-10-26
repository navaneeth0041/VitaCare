import 'package:flutter/material.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  int _selectedTabIndex = 0; // 0 for 'View Details', 1 for 'Reports'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          _buildTabs(),
          Expanded(
            child: _selectedTabIndex == 0 ? _buildViewDetails() : _buildReports(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your image asset
        ),
        const SizedBox(height: 10),
        const Text(
          'Akanksha Deo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoBadge('60 Years'),
            _buildInfoBadge('Female'),
            _buildInfoBadge('AB+'),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton('View Details', 0),
        _buildTabButton('Reports', 1),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.red : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildSectionTitle('Personal Information'),
          _buildInfoRow('Address', 'Bangalore'),
          _buildInfoRow('Blood Group', 'B+'),
          _buildInfoRow('Phone no.', '9999999999'),
          const Divider(height: 30, thickness: 1.5),
          _buildSectionTitle('Emergency Contact Details'),
          _buildInfoRow('Contact Name', 'Astha'),
          _buildInfoRow('Relationship', 'Daughter'),
          _buildInfoRow('Contact Number', '9999999999'),
          const Divider(height: 30, thickness: 1.5),
          _buildSectionTitle('Passed Appointments'),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/doctor_profile.png'), // Replace with your doctor image asset
            ),
            title: const Text('Dr. Inara Isani'),
            subtitle: const Text('Heart Surgeon, Delhi'),
            trailing: const Text('02:00 PM'),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View all',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReports() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildSectionTitle('Doctor Prescriptions'),
          _buildReportItem('Dr. Inara Isani Prescription', 'Sunday, 2nd March 2024'),
          _buildReportItem('Dr. Inara Isani Prescription', 'Sunday, 2nd March 2024'),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View all',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 30, thickness: 1.5),
          _buildSectionTitle('Lab Reports'),
          _buildReportItem('Blood Test Report', 'Sunday, 2nd March 2024'),
          _buildReportItem('X-Ray Report', 'Sunday, 2nd March 2024'),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View all',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blue),
        title: Text(title),
        subtitle: Text(date),
        trailing: TextButton(
          onPressed: () {}, // Add upload functionality here
          child: const Text(
            'Upload Report',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
