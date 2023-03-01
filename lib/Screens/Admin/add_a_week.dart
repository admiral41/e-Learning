import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddWeek extends StatefulWidget {
  @override
  _AddWeekState createState() => _AddWeekState();
}

class _AddWeekState extends State<AddWeek> {
  final _weekTitle = TextEditingController();
  final _weekDescription = TextEditingController();
  final _courseName = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String? _selectedCourse;
  void addWeek() async {
    _firestore.collection('weeks').add({
      'weekTitle': _weekTitle.text,
      'weekDescription': _weekDescription.text,
      'courseName': _selectedCourse,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }
  Future<List<String>> _getCourses() async {
    List<String> courses = [];
    QuerySnapshot querySnapshot = await _firestore.collection('courses').get();
    querySnapshot.docs.forEach((doc) {
      courses.add((doc.data() as Map)['title'] as String);
    });
    return courses;
  }

  @override
  void dispose() {
    _weekTitle.dispose();
    _weekDescription.dispose();
    _courseName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Add Week'),
          backgroundColor: Color.fromARGB(255,21, 21, 21)
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _weekTitle,
                  decoration: InputDecoration(
                    labelText: 'Enter week title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _weekDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Enter week description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                child: FutureBuilder<List<String>>(
                  future: _getCourses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton<String>(
                        hint: Text("Select Course",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        value: _selectedCourse,
                        items: snapshot.data!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),


              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: addWeek,
                  child: Text(
                    'Add week',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}