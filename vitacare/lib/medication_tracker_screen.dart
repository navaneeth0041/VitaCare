import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import 'add_medication_screen.dart';

class MedicationTrackerScreen extends StatefulWidget {
  @override
  _MedicationTrackerScreenState createState() => _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> datesInMonth;

  @override
  void initState() {
    super.initState();
    datesInMonth = _generateDatesInMonth(selectedDate);
  }

  List<DateTime> _generateDatesInMonth(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    return List<DateTime>.generate(daysInMonth,
        (i) => DateTime(date.year, date.month, i + 1));
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      datesInMonth = _generateDatesInMonth(date);
      Provider.of<MedicationProvider>(context, listen: false)
          .fetchMedications(selectedDate);
    });
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
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        color: Colors.blue[50],
                        child: ListTile(
                          title: Text(
                            med.name,
                            style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Frequency: ${med.frequency}"),
                          leading: med.imageUrl.isNotEmpty
                              ? Image.network(med.imageUrl, width: 50)
                              : Icon(Icons.medication, color: Colors.blueAccent),
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
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => AddMedicationScreen(date: selectedDate)),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
