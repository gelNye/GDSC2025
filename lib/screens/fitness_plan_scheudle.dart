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

  Future<String?> _fetchExerciseInstructions(String exerciseName) async {
    const String apiKey = 'AIzaSyCN-FeqVTOCgcCPvwLSLDE6M1VNVvO0LEQ'; // Gemini API Key
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Explain in simple steps how to perform the exercise: $exerciseName. Also describe what the movement looks like."
            }
          ]
        }
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      final data = jsonDecode(response.body);

      final generatedTextRaw = data['candidates']?[0]?['content']?['parts']?[0]
              ?['text'] ??
          'No instructions available.';
      return generatedTextRaw
          .replaceAll(RegExp(r'```json'), '')
          .replaceAll(RegExp(r'```'), '')
          .trim();
    } catch (e) {
      print('Error: $e');
      return 'Failed to load instructions.';
    }
  }

  Future<String?> _fetchExerciseImage(String query) async {
    const String pexelsApiKey = 'lf8thiJpw4FYnDzB24g3jMQd8t3dN6xPjlur3WAa0vNtFZwiNr0tMg1k'; // Replace with real key
    final Uri url =
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=1');

    final response = await http.get(url, headers: {
      'Authorization': pexelsApiKey,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List photos = data['photos'];
      if (photos.isNotEmpty) {
        return photos[0]['src']['medium']; // You can use 'original' if preferred
      } else {
        return null;
      }
    } else {
      print('Image load failed: ${response.statusCode}');
      return null;
    }
  }

  void _showExerciseDialog(String exerciseName) async {
    setState(() => _loading = true);
    final instructions = await _fetchExerciseInstructions(exerciseName);
    final imageUrl = await _fetchExerciseImage(exerciseName);
    setState(() => _loading = false);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How to do $exerciseName'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (imageUrl != null)
                Image.network(imageUrl)
              else
                SizedBox.shrink(),
              SizedBox(height: 12),
              MarkdownBody(data: instructions ?? 'No details available.'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK')),
        ],
      ),
    );
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Reps: ${exercise['reps']}'),
                              Text('Sets: ${exercise['sets']}'),
                              Text(
                                  'Rest Duration: ${exercise['rest_duration']}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.help_outline),
                          tooltip: 'How to do this exercise',
                          onPressed: () =>
                              _showExerciseDialog(exercise['name']),
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
