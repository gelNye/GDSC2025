import 'package:flutter/material.dart';

class DailyExercises extends StatefulWidget {
  final List<dynamic> exercises;

  const DailyExercises({super.key, required this.exercises});

  @override
  _DailyExercisesState createState() => _DailyExercisesState();
}

class _DailyExercisesState extends State<DailyExercises> {
  late List<bool> _completedExercises;

  @override
  void initState() {
    super.initState();
    _completedExercises = List<bool>.filled(widget.exercises.length, false);
  }

  void _toggleCheckbox(int index) {
    setState(() {
      _completedExercises[index] = !_completedExercises[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Exercises')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Checkbox(
                    value: _completedExercises[index],
                    onChanged: (bool? value) {
                      _toggleCheckbox(index);
                    },
                  ),
                  Expanded(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
