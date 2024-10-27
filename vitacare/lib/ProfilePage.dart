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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Patient Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5A6AF5)), // Bluish accent
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          _buildTabs(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedTabIndex == 0 ? _buildViewDetails() : _buildReports(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/profile_picture.png'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Arun Kumar',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF223365)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoBadge('60 Years'),
            _buildInfoBadge('Male'),
            _buildInfoBadge('B+'),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE1EBFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF5A6AF5)),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF5A6AF5) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? const Color(0xFF5A6AF5) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          _buildSectionTitle('Personal Information'),
          _buildInfoRow('Address', 'Bangalore'),
          _buildInfoRow('Blood Group', 'B+'),
          _buildInfoRow('Phone no.', '9446449855'),
          const Divider(height: 30, thickness: 1.5),
          _buildSectionTitle('Emergency Contact Details'),
          _buildInfoRow('Contact Name', 'Astha'),
          _buildInfoRow('Relationship', 'Daughter'),
          _buildInfoRow('Contact Number', '62388440032'),
          const Divider(height: 30, thickness: 1.5),
          _buildSectionTitle('Passed Appointments'),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/doctor_profile.png'),
            ),
            title: const Text('Dr. Inara Isani', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Heart Surgeon, Delhi'),
            trailing: const Text('02:00 PM', style: TextStyle(color: Color(0xFF5A6AF5))),
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
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          _buildSectionTitle('Doctor Prescriptions'),
          _buildReportItem('Dr. Inara Isani Prescription', 'Sunday, 2nd March 2024'),
          _buildReportItem('Dr. Mishra Kumar Prescription', 'Sunday, 7th March 2024'),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF223365)),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF223365)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String date) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.description, color: Color(0xFF5A6AF5)),
        title: Text(title, style: const TextStyle(color: Color(0xFF223365), fontWeight: FontWeight.w600)),
        subtitle: Text(date, style: const TextStyle(color: Colors.black54)),
        trailing: TextButton(
          onPressed: () {}, // Add upload functionality here
          child: const Text(
            'Upload Report',
            style: TextStyle(color: Color(0xFF5A6AF5)),
          ),
        ),
      ),
    );
  }
}
