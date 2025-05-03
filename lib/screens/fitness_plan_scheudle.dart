import 'package:flutter/material.dart';

class FitnessPlanSchedule extends StatelessWidget {
  final List<dynamic> exercises;

  const FitnessPlanSchedule({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Fitness Plan')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'] ?? 'Unnamed Exercise',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Reps: ${exercise['reps']}'),
                  Text('Sets: ${exercise['sets']}'),
                  Text('Rest Duration: ${exercise['rest_duration']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
