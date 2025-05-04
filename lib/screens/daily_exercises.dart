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
      appBar: AppBar(
        title: Text(
          'Daily Exercises',
          style: TextStyle(
            fontSize: 30, // Increase this value to make the text bigger
            fontWeight: FontWeight.bold, // Optional: Makes text bold
            color: Colors.black, // Ensures text color remains visible
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 175, 114, 255), const Color.fromARGB(255, 255, 116, 156)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 210, 175, 255), const Color.fromARGB(255, 255, 182, 202)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _remainingExercises.isEmpty
            ? Center(child: Text(
                'All exercises completed! 🎉', 
                style: 
                  TextStyle(
                    color: Colors.black,
                    fontSize: 48)
                )
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _remainingExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _remainingExercises[index];
                  return Card(
                    color: const Color.fromARGB(255, 255, 241, 230),
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Tooltip(
                            message: 'Mark exercise as completed', // Customize the tooltip text
                            child: Checkbox(
                              value: false,
                              onChanged: (_) => _completeExercise(index),
                            ),
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
      ),

    );
  }
}
