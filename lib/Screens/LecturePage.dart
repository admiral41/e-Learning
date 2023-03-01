import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class LecturePage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> lecture;
  LecturePage({required this.lecture});

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  quill.QuillController? _controller;

  @override
  void initState() {
    super.initState();
    final doc = quill.Document.fromJson(widget.lecture['lectureContent']);
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lecture['lectureTitle']),

        backgroundColor: Colors.orange[500]!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: quill.QuillEditor.basic(
                  controller: _controller!,
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
