import 'package:flutter/material.dart';

class ProgressCalendarPage extends StatefulWidget {
  @override
  _ProgressCalendarPageState createState() => _ProgressCalendarPageState();
}

class _ProgressCalendarPageState extends State<ProgressCalendarPage> {
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
            crossAxisCount: 7, 
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _progress.length, // 30 days
          itemBuilder: (context, index) {
            bool isGood = _progress[index];
            return GestureDetector(
              onTap: () {
                
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
