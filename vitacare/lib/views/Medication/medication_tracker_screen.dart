import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vitacare/add_medication_screen.dart';
import 'package:vitacare/models/medication_model.dart';
import 'package:vitacare/providers/medication_provider.dart';
import 'package:vitacare/views/Medication/Add_Medication1.dart';

class MedicationTrackerScreen extends StatefulWidget {
  @override
  _MedicationTrackerScreenState createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> datesInMonth;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; // Declare here
  List<Medication> medications = [];

  @override
  void initState() {
    super.initState();
    datesInMonth = _generateDatesInMonth(selectedDate);
    // Initialize local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    // Fetch medications for the initial date
    _fetchMedications(selectedDate);
  }

 void _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Use default launcher icon

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


  void _fetchMedications(DateTime date) {
    Provider.of<MedicationProvider>(context, listen: false)
        .fetchMedications(date);
    medications = Provider.of<MedicationProvider>(context, listen: false).medications; // Fetch medications for the selected date
    _scheduleDailyNotifications(); // Schedule notifications whenever medications are fetched
  }

  List<Medication> getDailyMedications() {
    return medications.where((med) => med.frequency == 'daily').toList();
  }

  void _scheduleDailyNotifications() {
    final dailyMedications = getDailyMedications();

    for (var medication in dailyMedications) {
      for (var time in medication.reminders) {
        scheduleNotification(medication.name, time);
      }
    }
  }

  List<DateTime> _generateDatesInMonth(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    return List<DateTime>.generate(
      daysInMonth,
      (i) => DateTime(date.year, date.month, i + 1),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      datesInMonth = _generateDatesInMonth(date);
      _fetchMedications(selectedDate); // Fetch medications when a new date is selected
    });
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void scheduleNotification(String medicineName, String time) async {
    final timeParts = time.split(":");
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Use a unique notification ID based on the medicine name and time
    int notificationId = medicineName.hashCode + hour * 100 + minute;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Medication Reminder',
      'It\'s time to take $medicineName',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel_id',
          'Medication Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) _selectDate(picked);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today’s Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: datesInMonth.length,
              itemBuilder: (context, index) {
                DateTime date = datesInMonth[index];
                bool isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;

                return GestureDetector(
                  onTap: () => _selectDate(date),
                  child: Container(
                    width: 60,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                      ],
                    ),
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: medicationProvider.medications.isEmpty
                ? Center(child: Text("No logs for this date."))
                : ListView.builder(
                    itemCount: medicationProvider.medications.length,
                    itemBuilder: (ctx, index) {
                      final med = medicationProvider.medications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        color: Colors.blue[50],
                        child: ListTile(
                          title: Text(
                            med.name,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Frequency: ${med.frequency}"),
                              Text("Type: ${med.type}"),
                              Text(
                                " ${med.reminders.join(', ')}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          leading: med.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(med.imageUrl, width: 50),
                                )
                              : Icon(
                                  Icons.medication,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                          onTap: () {
                            // Navigate to detail/edit screen if needed
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddMedication(date: selectedDate,),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
