import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLecture extends StatefulWidget {
  @override
  _AddLectureState createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  final _lectureTitle = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _lectureContent = quill.QuillController.basic();
  final _focusNode = FocusNode(); // define a FocusNode instance

  String? _selectedWeek;
  List<String> _weeks = [];
  String? _selectedCourse;

  void addLecture() async {
    _firestore.collection('lectures').add({
      'lectureTitle': _lectureTitle.text,
      'week': _selectedWeek,
      'course': _selectedCourse,
      'lectureContent': _lectureContent.document.toDelta().toJson(),
      'createdAt': FieldValue.serverTimestamp(),

    });
    Navigator.pop(context);
  }


  Future<List<String>> _getWeeks(String? selectedCourse) async {
    List<String> weeks = [];
    if (selectedCourse != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('weeks')
          .where('courseName', isEqualTo: selectedCourse)
          .get();
      querySnapshot.docs.forEach((doc) {
        weeks.add((doc.data() as Map)['weekTitle'] as String);
      });
    }
    return weeks;
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
    _lectureTitle.dispose();
    _focusNode.dispose(); // dispose the FocusNode instance

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Lecture'),
        backgroundColor: Color.fromARGB(255, 21, 21, 21),
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
                  controller: _lectureTitle,
                  decoration: InputDecoration(
                    labelText: 'Enter lecture title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              FutureBuilder<List<String>>(
                future: _getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton<String>(
                      hint: Text(
                        "Select Course",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      value: _selectedCourse,
                      items: snapshot.data!.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          _selectedCourse = value;
                          _selectedWeek = null;
                        });
                        _weeks = await _getWeeks(_selectedCourse);
                        setState(() {}); // add this line to update the UI with the new list of weeks
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),

              FutureBuilder<List<String>>(
                future: Future.value(_weeks),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton<String>(
                      hint: Text(
                        "Select Weeks",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      value: _selectedWeek,
                      items: _weeks.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: _selectedCourse == null
                          ? null
                          : (value) {
                        setState(() {
                          _selectedWeek = value;
                        });
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),


              quill.QuillToolbar.basic(
                controller: _lectureContent,
                showItalicButton: true,
                showBoldButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showColorButton: true,
                showBackgroundColorButton: true,
                showClearFormat: true,
                showListNumbers: true,
                showListBullets: true,
                showQuote: true,
                showCodeBlock: true,
                showLink: true,

                key: UniqueKey(),
              ),
              quill.QuillEditor(
                controller: _lectureContent,
                autoFocus: true,
                expands: false,
                padding: EdgeInsets.zero,
                focusNode: _focusNode,
                scrollController: ScrollController(),
                scrollable: true,
                readOnly: false,
                placeholder: 'Enter lecture content',
              ),

              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: addLecture,
                  child: Text(
                    'Add Lecture',
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
