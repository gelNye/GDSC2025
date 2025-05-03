import 'package:flutter/material.dart';

class DailyExercises extends StatefulWidget {
  final List<dynamic> exercises;

  const DailyExercises({super.key, required this.exercises});

  @override
  _DailyExercisesState createState() => _DailyExercisesState();
}

class _DailyExercisesState extends State<DailyExercises> {
  late List<dynamic> _remainingExercises;

  @override
  void initState() {
    super.initState();
    _remainingExercises = List.from(widget.exercises); // Copy the exercises list
  }

  void _completeExercise(int index) {
    setState(() {
      _remainingExercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Exercises')),
      body: _remainingExercises.isEmpty
          ? Center(child: Text('All exercises completed! 🎉'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _remainingExercises.length,
              itemBuilder: (context, index) {
                final exercise = _remainingExercises[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (_) => _completeExercise(index),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['name'] ?? 'Unnamed Exercise',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
