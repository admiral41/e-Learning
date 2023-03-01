import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  File? _image;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }
  void createCourse() async {
    String imageUrl = '';
    if (_image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("images"+ DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }
    _firestore.collection('courses').add({
      'title': _title.text,
      'description': _description.text,
      'imageUrl': imageUrl
    });

    Navigator.pop(context);
  }



  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
        title: Text('Create Course'),
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
                  controller: _title,
                  decoration: InputDecoration(
                    labelText: 'Enter course title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Enter course description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.grey,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _image == null
                      ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Image(
                      image: AssetImage('assets/img/placeholder.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Image.file(
                    _image!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: createCourse,
                  child: Text(
                    'Create course',
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