import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class FitnessPlanSchedule extends StatefulWidget {
  final List<dynamic> exercises;

  const FitnessPlanSchedule({super.key, required this.exercises});

  @override
  State<FitnessPlanSchedule> createState() => _FitnessPlanScheduleState();
}

class _FitnessPlanScheduleState extends State<FitnessPlanSchedule> {
  bool _loading = false;
  String _description = '';

  Future<void> _fetchExerciseInstructions(String exerciseName) async {
    setState(() {
      _loading = true;
      _description = '';
    });

    const String apiKey = 'AIzaSyCN-FeqVTOCgcCPvwLSLDE6M1VNVvO0LEQ';
    const String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Explain in simple steps how to perform the exercise: $exerciseName."
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      final data = jsonDecode(response.body);

      final generatedTextRaw = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No instructions available.';
      final generatedText = generatedTextRaw
          .replaceAll(RegExp(r'```json'), '')
          .replaceAll(RegExp(r'```'), '')
          .trim();

      if (context.mounted) {
        showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('How to do $exerciseName'),
    content: SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: MarkdownBody(data: generatedText),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK')),
    ],
  ),
);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Fitness Plan')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        IconButton(
                          icon: Icon(Icons.help_outline),
                          tooltip: 'How to do this exercise',
                          onPressed: () => _fetchExerciseInstructions(exercise['name']),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
