import 'package:elearning/Widgets/BouncingButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddaUser extends StatefulWidget {
  const AddaUser({Key? key}) : super(key: key);

  @override
  State<AddaUser> createState() => _AddaUserState();
}

class _AddaUserState extends State<AddaUser> {
  final nameController = TextEditingController();
  final SchoolNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phonenoController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool passshow = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedRole = "user";
  void addUser() {
    try {
      _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((value) {
        if (_selectedRole == "admin") {
          _firestore
              .collection("admins")
              .doc(value.user?.uid)
              .set({
            "name": nameController.text.trim(),
            "school_name": SchoolNameController.text.trim(),
            "email": emailController.text.trim(),
            "phone_number": phonenoController.text.trim(),
            "password": passwordController.text.trim(),
            "role": _selectedRole,
          });
        } else {
          _firestore
              .collection("users")
              .doc(value.user?.uid)
              .set({
            "name": nameController.text.trim(),
            "school_name": SchoolNameController.text.trim(),
            "email": emailController.text.trim(),
            "phone_number": phonenoController.text.trim(),
            "password": passwordController.text.trim(),
            "role": _selectedRole,
          });
        }
        print("Successfully added user: ${emailController.text.trim()}");
      }).catchError((error) {
        print("Error adding user: $error");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
        title: Text("Add a User"),
          backgroundColor: Color.fromARGB(255,21, 21, 21)
      ),
      body: Padding(
        
        padding: EdgeInsets.only(top: 50),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10, 30, 10),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                contentPadding: EdgeInsets.all(5),
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: SchoolNameController,
                              decoration: InputDecoration(
                                  labelText: 'School Name',
                                  contentPadding: EdgeInsets.all(5),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your School name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'E-Mail',
                                  contentPadding: EdgeInsets.all(5),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: passwordController,
                              obscuringCharacter: '*',
                              decoration: InputDecoration(
                                  suffix: passshow == false
                                      ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passshow = true;
                                      });
                                    },
                                    icon: Icon(Icons.lock_open),
                                  )
                                      : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passshow = false;
                                      });
                                    },
                                    icon: Icon(Icons.lock),
                                  ),
                                  labelText: 'PASSWORD',
                                  contentPadding: EdgeInsets.all(5),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value!.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              obscureText: passshow == false ? true : false,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: phonenoController,
                              decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  contentPadding: EdgeInsets.all(5),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Text("Select a role:", style: TextStyle( fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                                SizedBox(width: 20.0),
                                DropdownButton<String>(
                                  value: _selectedRole,
                                  items: [
                                    DropdownMenuItem(
                                      value: "admin",
                                      child: Text("Admin"),
                                    ),
                                    DropdownMenuItem(
                                      value: "user",
                                      child: Text("User"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value!;
                                    });
                                  },
                                ),
                              ],
                            )

                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Bouncing(
                      onPress: () {},
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            addUser();
                          }
                        },
                        elevation: 0.0,
                        minWidth: MediaQuery.of(context).size.width,
                        color: Colors.green,
                        child: Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),

    );
  }
}


