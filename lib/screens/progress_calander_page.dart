import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class ProgressCalendarPage extends StatefulWidget {
  @override
  _ProgressCalendarPageState createState() => _ProgressCalendarPageState();
}

class _ProgressCalendarPageState extends State<ProgressCalendarPage> {
  final List<int> _progress = List.generate(30, (index) {
    if (index > 16) {
      return 0;
    } else if (index == 16) {
      return 1;
    } else {
      if (index % 4 == 0) {
        return 2;
      }
      if (index % 3 == 1) {
        return 3;
      }
      if (index % 5 == 4) {
        return 2;
      } else {
        return 3;
      }
    }
  });

  Future<void> _rateMyScore() async {
  int greenDays = _progress.where((val) => val == 3).length;
  int redDays = _progress.where((val) => val == 2).length;
  double totalResult = (greenDays/(greenDays + redDays))*10;

  String prompt =
      "Print the score $totalResult out of 10 and give feedback to a user based on their monthly progress. "
      "They marked $greenDays days as completed (green) and $redDays days as skipped (red). "
      "Be supportive and motivational roughly 90 to 200 words.";

  String response = await fetchGeminiResponse(prompt);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Your Monthly Score"),
      content: SingleChildScrollView(
        child: MarkdownBody(
          data: response,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Thanks!"),
        ),
      ],
    ),
  );
}


  Future<String> fetchGeminiResponse(String prompt) async {
    const String apiKey = 'AIzaSyCN-FeqVTOCgcCPvwLSLDE6M1VNVvO0LEQ';
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          "Couldn't understand the response.";
    } else {
      return "Failed to fetch feedback: ${response.reasonPhrase}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Progress Calendar',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 175, 114, 255),
                Color.fromARGB(255, 255, 116, 156),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 210, 175, 255),
              Color.fromARGB(255, 255, 182, 202),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _progress.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getColorForValue(_progress[index]),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton(
                onPressed: _rateMyScore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Rate My Score for the Month",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getColorForValue(int value) {
  switch (value) {
    case 0:
      return Colors.grey;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.red;
    case 3:
      return Colors.green;
    default:
      return Colors.transparent;
  }
}
