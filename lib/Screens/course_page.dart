import 'package:elearning/Screens/LecturePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursePage extends StatefulWidget {
  String courseTitle;
  CoursePage({required this.courseTitle});
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.courseTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Lessons',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<QuerySnapshot>(
                future: _firestore
                    .collection('weeks')
                    .where('courseName', isEqualTo: widget.courseTitle)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Text('Content is not available at this time');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var week = snapshot.data!.docs[index];
                          return Card(
                            child: ExpansionTile(
                              title: Text(
                                (week.data() as Map)['weekTitle'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                FutureBuilder<QuerySnapshot>(
                                  future: _firestore
                                      .collection('lectures')
                                      .where('week', isEqualTo: (week.data() as Map)['weekTitle'])
                                      .where('course', isEqualTo: widget.courseTitle)

                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Text('Lectures are not available at this time');
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            var lecture = snapshot.data!.docs[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => LecturePage(lecture: lecture),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  (lecture.data() as Map)['lectureTitle'],
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
