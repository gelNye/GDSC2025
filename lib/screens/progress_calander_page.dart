import 'package:flutter/material.dart';

class ProgressCalendarPage extends StatefulWidget {
  @override
  _ProgressCalendarPageState createState() => _ProgressCalendarPageState();
}

class _ProgressCalendarPageState extends State<ProgressCalendarPage> {
  final List<int> _progress = List.generate(30, (index) {
    if (index > 16) {
      return 0; // Greater than 16
    } else if (index == 16) {
      return 1; // Index 16
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

  void _rateMyScore() {
    int totalScore = 0;
    for (int value in _progress) {
      if (value == 3) {
        totalScore += 1;
      }
    }
    int maxScore = 0;
    for (int value in _progress) {
      if (value > 1) {
        maxScore += 1;
      }
    }

    double ratingOutOf10 = (totalScore / maxScore) * 10;
    String encouragement;

    if (ratingOutOf10 >= 8) {
      encouragement = "Amazing job! Keep pushing yourself!";
    } else if (ratingOutOf10 >= 5) {
      encouragement = "You're doing well! A little more consistency and you'll hit your goals!";
    } else {
      encouragement = "Every step counts. Keep going — you've got this!";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Monthly Score"),
        content: Text(
          "Score: ${ratingOutOf10.toStringAsFixed(1)}/10\n\n$encouragement",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Progress Calendar'),
        foregroundColor: Colors.black,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 175, 114, 255),
                const Color.fromARGB(255, 255, 116, 156)
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
              const Color.fromARGB(255, 210, 175, 255),
              const Color.fromARGB(255, 255, 182, 202)
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
              backgroundColor: Colors.white, // White background
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              ),
              ),
              child: Text(
              "Rate My Score for the Month",
                style: TextStyle(
                fontSize: 12,
                  color: Colors.grey, // Grey text
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
