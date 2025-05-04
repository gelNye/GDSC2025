import 'package:flutter/material.dart';

class ProgressCalendarPage extends StatefulWidget {
  @override
  _ProgressCalendarPageState createState() => _ProgressCalendarPageState();
}

class _ProgressCalendarPageState extends State<ProgressCalendarPage> {
  //final List<bool> _progress = List.generate(30, (index) => index % 2 == 0);
  final List<int> _progress = List.generate(30, (index) {
    if (index > 16) {
      return 0; // Greater than 16
    } else if (index == 16) {
      return 1; // Index 16
    } else {
      // Alternate between 2 and 3 for indices less than 16
      if(index % 4 == 0){
        return 2;
      }
      if(index % 3 == 1){
        return 3;
      }
      if(index % 5 == 4){
        return 2;
      }
      else{
        return 3;
      }
    }
  });

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
          
          child: GridView.builder(
            
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, 
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _progress.length, // 30 days
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  
                },
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
        )
      ),
    );
  }
}
Color _getColorForValue(int value) {
  switch (value) {
    case 0:
      return Colors.grey;  // Grey for 0
    case 1:
      return Colors.blue; // White for 1
    case 2:
      return Colors.red;   // Red for 2
    case 3:
      return Colors.green; // Green for 3
    default:
      return Colors.transparent;  // Default case (optional)
  }
}
