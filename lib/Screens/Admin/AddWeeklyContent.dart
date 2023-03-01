import 'package:flutter/material.dart';
class AddWeeklyContent extends StatefulWidget {
  final String courseTitle;
  final String courseImage;
  final String courseDescription;

  AddWeeklyContent({
    required this.courseTitle,
    required this.courseImage,
    required this.courseDescription,
  });

  @override
  _AddWeeklyContentState createState() => _AddWeeklyContentState();
}

class _AddWeeklyContentState extends State<AddWeeklyContent> {
  int _weekCounter = 1;
  List<TextEditingController> _weekContentControllers = [
    TextEditingController(),
  ];

  void _addWeek() {
    setState(() {
      _weekCounter++;
      _weekContentControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Weekly Content"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Course Title: ${widget.courseTitle}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            SizedBox(height: 8.0),
            Text("Course Image: ${widget.courseImage}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            SizedBox(height: 8.0),
            Text("Course Description: ${widget.courseDescription}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            SizedBox(height: 16.0),
            Text("Week Content", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            for (int i = 0; i < _weekCounter; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text("Week ${i + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _weekContentControllers[i],
                    decoration: InputDecoration(
                      hintText: "Enter week content",
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _addWeek,
                  child: Text("Add Week"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}