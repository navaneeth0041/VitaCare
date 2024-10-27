import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Uuid _uuid = Uuid();

  String _generateGoogleMeetLink() {
    return 'https://meet.google.com/${_uuid.v4().substring(0, 10)}';
  }

  Future<void> _createMeeting() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    final googleMeetLink = _generateGoogleMeetLink();

    await FirebaseFirestore.instance.collection('events').add({
      'title': title,
      'description': description,
      'link': googleMeetLink,
      'createdAt': Timestamp.now(),
    });

    _titleController.clear();
    _descriptionController.clear();

    _showSnackBar("Meeting created successfully!");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.indigo.withOpacity(0.9),
    ));
  }

  Future<void> _showCreateMeetingDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: Text("Create New Meeting", style: TextStyle(color: Colors.indigo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Meeting Title",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.indigo)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                _createMeeting();
                Navigator.of(context).pop();
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMeetingCard(DocumentSnapshot doc) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc['title'] ?? 'Untitled',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 8),
            Text(
              doc['description'] ?? 'No Description',
              style: TextStyle(fontSize: 15, color: Colors.blueGrey),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final url = doc['link'];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      _showSnackBar("Could not open meeting link.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: Text("Join Meeting"),
                ),
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.indigoAccent, size: 28),
                  onPressed: () {
                    _showChatDialog(doc);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChatDialog(DocumentSnapshot doc) async {
    final TextEditingController _chatController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chat for ${doc['title']}"),
          content: TextField(
            controller: _chatController,
            decoration: InputDecoration(
              labelText: "Enter message",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                // handle message send
                _chatController.clear();
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Meeting Hub", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white, size: 28),
            onPressed: () => _showCreateMeetingDialog(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return _buildMeetingCard(documents[index]);
            },
          );
        },
      ),
    );
  }
}
