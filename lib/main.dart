import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'screens/fitness_plan_scheudle.dart'; // Import the new screen

void main() {
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FitnessGoalScreen(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) {
        final exercises = state.extra as List<dynamic>;
        return FitnessPlanSchedule(exercises: exercises);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Goals App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}


class FitnessGoalScreen extends StatefulWidget {
  @override
  _FitnessGoalScreenState createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> _sendToGemini(String goal) async {
  setState(() {
    _isLoading = true;
    _response = '';
  });

  const String apiKey = 'AIzaSyCN-FeqVTOCgcCPvwLSLDE6M1VNVvO0LEQ';
  const String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {
            "text": "Generate a JSON array of exercises for the following fitness goal: $goal. Each object should have exactly these keys: 'name', 'reps', 'sets', and 'rest_duration'. Do not include any explanation or formatting — only return the JSON array."
          }
        ]
      }
    ]
  });

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    final data = jsonDecode(response.body);

    final generatedText = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '[]';

    // Try parsing the response text to JSON
    final List<dynamic> exercises = jsonDecode(generatedText);

    // Navigate to schedule page if context is still valid
    if (context.mounted) {
      context.push('/schedule', extra: exercises);
    }
  } catch (e) {
    setState(() {
      _response = 'Error: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Fitness Goals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'What are your fitness goals?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _sendToGemini(_controller.text),
              child: Text('Generate Plan'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Text(_response),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
