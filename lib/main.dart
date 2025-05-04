import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'screens/fitness_plan_scheudle.dart';
import 'screens/daily_exercises.dart';
import 'screens/progress_calander_page.dart'; // Import the calendar page

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
      path: '/home',
      builder: (context, state) {
        final exercises = state.extra as List<dynamic>;
        return FitnessHomeWithNavBar(exercises: exercises);
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
    const String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Generate a JSON array of exercises for the following fitness goal: $goal. Each object should have exactly these keys: 'name', 'reps', 'sets', and 'rest_duration'. Do not include any explanation or formatting — only return the JSON array."
            }
          ]
        }
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      final data = jsonDecode(response.body);
      final generatedTextRaw =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '[]';

      final generatedText = generatedTextRaw
          .replaceAll(RegExp(r'```json'), '')
          .replaceAll(RegExp(r'```'), '')
          .trim();

      final List<dynamic> exercises = jsonDecode(generatedText);

      if (context.mounted) {
        context.push('/home', extra: exercises);
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
      appBar: AppBar(
        title: Text(
          'Jym.ai',
          style: TextStyle(
            fontSize: 30, // Increase this value to make the text bigger
            fontWeight: FontWeight.bold, // Optional: Makes text bold
            color: Colors.black, // Ensures text color remains visible
          ),
        ),

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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "    Jym.ai uses the power of Google Gemini to streamline your experience at the gym. Jym.ai is an excellent tool for beginners that tailors a unique workout based on your prompt. A series of exercises will be generated alongside the recommended number of reps, sets and duration of rest. ",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
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
      ),
    );
  }

}

class FitnessHomeWithNavBar extends StatefulWidget {
  final List<dynamic> exercises;

  const FitnessHomeWithNavBar({super.key, required this.exercises});

  @override
  State<FitnessHomeWithNavBar> createState() => _FitnessHomeWithNavBarState();
}

class _FitnessHomeWithNavBarState extends State<FitnessHomeWithNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FitnessPlanSchedule(exercises: widget.exercises),
      DailyExercises(exercises: widget.exercises),
      ProgressCalendarPage(), // Add the calendar page here
    ];

    return Scaffold(
      //appBar: AppBar(title: Text('Fitness App')),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Plan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: 'Daily'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'), // Calendar Tab
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
