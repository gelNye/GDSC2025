import 'package:flutter/material.dart';

class ProgressCalendarPage extends StatefulWidget {
  @override
  _ProgressCalendarPageState createState() => _ProgressCalendarPageState();
}

class _ProgressCalendarPageState extends State<ProgressCalendarPage> {
  // Simulating the progress data (green for good, red for bad)
  // You could replace this with real data from a database or shared preferences
  final List<bool> _progress = List.generate(30, (index) => index % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Progress Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 boxes in a row (one for each day of the week)
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _progress.length, // 30 days
          itemBuilder: (context, index) {
            bool isGood = _progress[index];
            return GestureDetector(
              onTap: () {
                // You can add functionality here when a user taps a day
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isGood ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Day ${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
